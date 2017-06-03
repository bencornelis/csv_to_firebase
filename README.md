https://lit-caverns-34623.herokuapp.com/

### About

Upload spreadsheet data to your firebase app. It generally works for files with up to 30,000 rows, but larger files will lead to a heroku timeout.

The only assumption made about the spreadsheet form is that all column names, which will be keys in firebase, are on the top row.

### Setup

To get started run:
* `bundle`
* `rake db:create`
* `rake db:migrate`

To run the tests:
* `rake db:test:prepare`
* `rspec`

Before uploading a spreadsheet, make sure your firebase app gives full write access.
