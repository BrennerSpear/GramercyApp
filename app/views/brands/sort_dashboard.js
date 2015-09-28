$('#post_list').html('<%= escape_javascript render(@posts) %>');
$('#date-sort').replaceWith('<%= escape_javascript link_to @date_name, sort_dashboard_path(format: :js, name: @date_sort, length_of_time: @length_of_time), method: "get", remote: true, class: "btn btn-primary", id: "date-sort", style: "display: inline-block;"  %>');
$('#like-sort').replaceWith('<%= escape_javascript link_to @like_name, sort_dashboard_path(format: :js, name: @like_sort, length_of_time: @length_of_time), method: "get", remote: true, class: "btn btn-primary", id: "like-sort", style: "display: inline-block;"  %>');
$('#follower-sort').replaceWith('<%= escape_javascript link_to @follower_name, sort_dashboard_path(format: :js, name: @follower_sort, length_of_time: @length_of_time), method: "get", remote: true, class: "btn btn-primary", id: "follower-sort", style: "display: inline-block;"  %>');
$('#coupon-sort').replaceWith('<%= escape_javascript link_to @coupon_name, sort_dashboard_path(format: :js, name: @coupon_sort, length_of_time: @length_of_time), method: "get", remote: true, class: "btn btn-primary", id: "coupon-sort", style: "display: inline-block;"  %>');