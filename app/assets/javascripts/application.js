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
      var getTemplate = function() {
        return $(".template").last();
      }

      var getStartButton = function() {
        return getTemplate().find("button.start");
      }

      var disableStartButton = function() {
        $startButton = getStartButton();
        $startButton.prop("disabled", true);
        $startButton.addClass("faded");
      }

      this.on("addedfile", function(file) {
        if (!$("#firebase_app").val()) {
          this.removeFile(file);
          $("#firebase_app_required").text("Firebase app required!");
          $("#firebase_app").addClass("field-required");

          $("#firebase_app").keyup(function() {
            $("#firebase_app_required").empty();
            $("#firebase_app").removeClass("field-required");
          })
          return;
        }

        var formData = new FormData();
        formData.append("file", file);

        // get column headers and display them
        $.ajax({
          dataType: "json",
          url: "/column_headers",
          type: "POST",
          data: formData,
          cache: false,
          contentType: false,
          processData: false
        }).done(function(response) {
          var $headers = getTemplate().find(".headers");
          if (response.error) {
            $headers.text("Error: " + response.error);
            $headers.addClass("error")

            disableStartButton();
          } else {
            $headers.text("Column headers: " + response.column_headers.join(", "));
          }
        });

        // hook up start button
        var dropzone = this;
        getStartButton().click(function() { dropzone.enqueueFile(file); });
      });

      this.on("totaluploadprogress", function(progress) {
        getTemplate().find(".progress-bar").width(progress + "%");
      });

      this.on("success", function(file, response) {
        getTemplate().find(".message").text(response.message)
      });

      this.on("sending", function(file, xhr, formData) {
        var firebaseApp = $("#firebase_app").val();
        formData.append("firebase_app", firebaseApp);

        disableStartButton();
      });

      this.on("queuecomplete", function(progress) {
        $(".progress-bar").width("0%");
      });
    }
  }
});
