$(function() {
  $('#micropost_image').on('change', function() {
    const file_max_size = 5
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > file_max_size) {
      alert("<%= I18n.t('.large_img_error') %>");
    }
  });
})
