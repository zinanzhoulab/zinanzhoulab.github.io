require 'yaml'
require 'liquid'
require 'minitest/autorun'

class AuthorshipTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  DATA = YAML.load_file(File.join(ROOT, '_data/authorship.yaml'))
  CITATIONS = YAML.load_file(File.join(ROOT, '_data/citations.yaml'))
  TEMPLATE = File.read(File.join(ROOT, '_includes/citation-authors.html'))

  def render_authors(id, authors, data = DATA)
    Liquid::Template.parse(TEMPLATE, error_mode: :strict).render!(
      'site' => { 'data' => { 'authorship' => data } },
      'include' => { 'id' => id, 'authors' => authors }
    )
  end

  def test_verified_names_match_the_current_citations
    CITATIONS.each do |citation|
      roles = DATA[citation['id']]
      next unless roles
      assert_match(%r{\Ahttps://}, roles['source'])
      refute_empty roles['evidence']
      %w[cofirst corresponding].each do |role|
        names = roles[role] || []
        assert_equal names.uniq, names
        names.each do |name|
          assert_includes citation['authors'], name, "#{citation['id']}: #{role} name mismatch"
        end
      end
    end
  end

  def test_each_current_citation_renders_all_its_verified_markers
    CITATIONS.each do |citation|
      roles = DATA[citation['id']] || {}
      html = render_authors(citation['id'], citation['authors'])
      assert_equal (roles['cofirst'] || []).size, html.scan('title="Co-first author; equal contribution"').size
      assert_equal (roles['corresponding'] || []).size, html.scan('title="Corresponding author"').size
      refute_includes html, 'Liquid error'
    end
  end

  def test_unknown_doi_and_null_roles_do_not_invent_markers
    assert_equal 'Author One, Author Two', render_authors('doi:unknown', ['Author One', 'Author Two'])
    data = { 'test' => { 'cofirst' => nil, 'corresponding' => nil } }
    assert_equal 'Author One', render_authors('test', ['Author One'], data)
  end

  def test_both_roles_can_be_shown_for_one_author
    html = render_authors('doi:10.1016/j.cell.2026.03.040', ['August Yue Huang'])
    assert_includes html, 'August Yue Huang<sup'
    assert_includes html, '&#8224;</span>,<span'
  end

  def test_middle_annotated_authors_are_not_hidden
    authors = (1..20).map { |i| "Author #{i}" }
    data = { 'test' => { 'cofirst' => ['Author 8'], 'corresponding' => ['Author 12'] } }
    html = render_authors('test', authors, data)
    assert_includes html, 'Author 8<sup'
    assert_includes html, 'Author 12<sup'
    refute_includes html, 'Author 9'
    assert_equal 3, html.scan('...').size
    assert_includes html, 'Author 20'
  end

  def test_unannotated_long_lists_retain_existing_abbreviation
    authors = (1..12).map { |i| "Author #{i}" }
    expected = (authors.first(5) + ['...'] + authors.last(5)).join(', ')
    assert_equal expected, render_authors('unknown', authors)
  end

  def test_names_are_escaped_and_commas_do_not_split_authors
    assert_equal 'A &amp; B, Smith, Jr.', render_authors('unknown', ['A & B', 'Smith, Jr.'])
  end

  def test_empty_author_lists
    assert_equal '[no author info]', render_authors('unknown', [])
  end

  def test_cea_first_page_confirms_only_one_corresponding_author
    roles = DATA['doi:10.1016/j.bios.2016.06.043']
    assert_equal [], roles['cofirst']
    assert_equal ['Xiaoming Yang'], roles['corresponding']
    refute roles.key?('needs_review')
  end

  def test_preprint_roles_are_not_copied_from_journal_version
    preprint = DATA['doi:10.1101/2024.01.03.574078']
    journal = DATA['doi:10.1016/j.cell.2026.03.040']
    refute_includes preprint['cofirst'], 'Liz Enyenihi'
    assert_includes journal['cofirst'], 'Liz Enyenihi'
  end

  def test_als_preprint_correspondence_is_confirmed_by_coauthor
    roles = DATA['doi:10.1101/2023.11.30.569436']
    assert_equal ['Clotilde Lagier-Tourenne', 'Eunjung Alice Lee', 'Christopher A. Walsh'], roles['corresponding']
    assert_includes roles['evidence'], 'explicitly confirmed'
    refute roles.key?('needs_review')
  end

  def test_clonal_hematopoiesis_roles_match_supplied_manuscript
    roles = DATA['doi:10.1101/2025.05.19.654981']
    assert_equal ['Jaejoon Choi', 'Kyung Sun Park', 'Yann Le Guen'], roles['cofirst']
    assert_equal ['Jong-Won Kim', 'August Yue Huang', 'Eunjung Alice Lee'], roles['corresponding']
    refute roles.key?('needs_review')
  end

  def test_citation_legends_follow_verified_roles
    source = File.read(File.join(ROOT, '_includes/citation.html'))
    legend = source[/\{% assign authorship =.*?(?=<div class="citation-details">)/m]
    refute_nil legend
    template = Liquid::Template.parse(legend, error_mode: :strict)
    render = lambda do |id|
      template.render!('site' => { 'data' => { 'authorship' => DATA } }, 'citation' => { 'id' => id })
    end
    assert_includes render.call('doi:10.1016/j.cell.2026.03.040'), 'Co-first authors; equal contribution.'
    assert_includes render.call('doi:10.1016/j.cell.2026.03.040'), 'Co-corresponding authors.'
    single = render.call('doi:10.1002/rcm.6958')
    assert_includes single, '* Corresponding author.'
    refute_includes single, 'Co-first'
    assert_includes render.call('doi:10.1101/2025.05.19.654981'), 'Co-corresponding authors.'
    assert_empty render.call('doi:unknown').strip
  end
end
