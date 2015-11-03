//helper functions
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
    accept: function(file, done) {
      var formData = new FormData();
      formData.append("file", file);

      $("body").addClass("loading");

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
        $("body").removeClass("loading");

        if (response.error) {
          disableStartButton();
          done(response.error);
        } else {
          var $metadata = getTemplate().find(".file-metadata");
          $metadata.html("<p>Column headers: " + response.headers.join(", ") + "</p>" +
                         "<p>Rows: " + response.rows_count + "</p>");
          done();
        }
      });

    },

    init: function() {
      this.on("drop", function(e) {
        var last_file = this.files[0];
        if (last_file) {
          this.removeFile(last_file);
        }
      });

      this.on("addedfile", function(file) {

        // require firebase app to be specified
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

        // hook up start button
        var dropzone = this;
        getStartButton().click(function() {
          dropzone.enqueueFile(file);
        });
      });

      this.on("uploadprogress", function(file, progress) {
        if (progress === 100) {
          $(".upload-status").text("Sending to firebase...");
        }
      });

      this.on("success", function(file, response) {
        $(".upload-status").empty();
        $message = getTemplate().find(".message");

        if (response.error) {
          $message.text("Error: " + response.error);
          getTemplate().find(".upload-failure").show();
        } else {
          getTemplate().find(".upload-success").show();

          var url = response.url;
          $message.html(
            "<p>Upload successful!</p>" +
            "<p>Entries uploaded to <a href ='" + url + "'>" + url + "</a></p>"
          );
        }
      });

      this.on("sending", function(file, xhr, formData) {
        var firebaseApp = $("#firebase_app").val();
        formData.append("firebase_app", firebaseApp);

        $(".upload-status").text("Uploading file...")
        disableStartButton();
      });
    }
  }
});
