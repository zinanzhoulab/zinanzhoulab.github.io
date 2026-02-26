/*
  creates link next to each heading that links to that section.
*/

{
  // scroll to target of url hash
  const scrollToTarget = () => {
    const id = window.location.hash.replace("#", "");
    const target = document.getElementById(id);

    if (!target) return;
    const offset = document.querySelector("header").clientHeight || 0;
    window.scrollTo({
      top: target.getBoundingClientRect().top + window.scrollY - offset,
      behavior: "smooth",
    });
  };

  // after page loads
  window.addEventListener("load", scrollToTarget);
  window.addEventListener("tagsfetched", scrollToTarget);

  // when hash nav happens
  window.addEventListener("hashchange", scrollToTarget);
}
