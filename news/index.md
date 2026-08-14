---
title: News
nav:
  order: 5
  tooltip: Musings and miscellany
---

# {% include icon.html icon="fa-solid fa-feather-pointed" %}News

{% include section.html %}

{% include search-box.html %}

{% assign news_tags = site.data.news | map: "tags" | join: "," %}
{% include tags.html tags=news_tags %}

{% include search-info.html %}

{% include list.html data="news" component="post-excerpt" hide_image=true %}
