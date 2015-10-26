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
        return $(".template").first();
      }

      var getStartButton = function() {
        return getTemplate().find("button.start");
      }

      var disableStartButton = function() {
        $startButton = getStartButton();
        $startButton.prop("disabled", true);
        $startButton.addClass("faded");
      }

      this.on("drop", function(e) {
        var last_file = this.files[0];
        if (last_file) {
          this.removeFile(last_file);
        }
      });

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

        // get file metadata and display
        $.ajax({
          dataType: "json",
          url: "/file_metadata",
          type: "POST",
          data: formData,
          cache: false,
          contentType: false,
          processData: false
        }).done(function(response) {
          var $metadata = getTemplate().find(".file-metadata");
          if (response.error) {
            $metadata.html("<p>Error: " + response.error + "</p>");
            $metadata.addClass("error")

            disableStartButton();
          } else {
            $metadata.html("<p>Column headers: " + response.column_headers.join(", ") + "</p>" +
                           "<p>Rows: " + response.rows_count + "</p>");
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
        $message = getTemplate().find(".message")

        if (response.error) {
          $message.text(response.error);
          getTemplate().find(".upload-failure").show();
        } else {
          getTemplate().find(".upload-success").show();

          var url = response.upload.url;
          $message.html(
            "<p>Upload successful!</p>" +
            "<p>Entries uploaded to <a href ='" + url + "'>" + url + "</a></p>"
          );
        }
      });

      this.on("sending", function(file, xhr, formData) {
        var firebaseApp = $("#firebase_app").val();
        formData.append("firebase_app", firebaseApp);

        disableStartButton();
      });
    }
  }
});
