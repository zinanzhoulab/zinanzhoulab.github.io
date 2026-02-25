---
title: Team
nav:
  order: 4
  tooltip: About our team
---

# {% include icon.html icon="fa-solid fa-users" %}Team

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role == 'principal-investigator' and group != 'hidden'" %}
{% include list.html data="members" component="portrait" filter="role != 'principal-investigator' and group != 'hidden' and group != 'alum'" %}

{% include section.html %}

<h2 class="center">ALUMNI</h2>

{% include list.html data="members" component="portrait" filter="group == 'alum' and group != 'hidden'" %}
