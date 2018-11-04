$('#posts .data').append('<%= j render @posts %>')
$('#pagination').html('<%= j will_paginate @posts %>')

# A menos que haya una siguiente pagina
<% unless @posts.next_page  %>
$('#pagination').remove()
<%end%>
window.loading = false