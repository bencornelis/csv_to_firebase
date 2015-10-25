// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require dropzone

$(function() {
  var previewNode = $(".template");
  previewNode.id = "";
  var previewTemplate = previewNode.parent().html();
  previewNode.remove();

  Dropzone.options.newUpload = { // The camelized version of the ID of the form element
    thumbnailWidth: 80,
    thumbnailHeight: 80,
    parallelUploads: 20,
    previewTemplate: previewTemplate,
    autoQueue: false, // Make sure the files aren't queued until manually added
    previewsContainer: "#previews", // Define the container to display the previews
    acceptedFiles: ".csv,.xls,.xlsx",

    init: function() {
      this.on("addedfile", function(file) {
        var $template = $(".template").last()

        var formData = new FormData();
        formData.append("file", file);
        $.ajax({
          dataType: "json",
          url: "/column_headers",
          type: "POST",
          data: formData,
          cache: false,
          contentType: false,
          processData: false
        }).done(function(response) {
          $template.find(".headers").text("Column headers: " + response.column_headers.join(", "))
        });

        var dropzone = this;
        $template.find("button.start").click(function() { dropzone.enqueueFile(file); });
      });

      this.on("totaluploadprogress", function(progress) {
        $(".template").last().find(".progress-bar").width(progress + "%");
      });

      this.on("success", function(file, response) {
        $(".template").last().find(".message").text(response.message)
      });

      this.on("sending", function(file, xhr, formData) {
        // $("#total-progress").style.opacity = "1";
        formData.append("firebase_app", $("#firebase_app").val());
        $(".template").last().find("button.start").prop("disabled", true);
      });

      this.on("queuecomplete", function(progress) {
        $(".progress-bar").width("0%");
      });
    }
  }
});
