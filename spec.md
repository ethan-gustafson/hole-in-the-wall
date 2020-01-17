# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
- [x] Use ActiveRecord for storing information in a database
- [x] Include more than one model class (e.g. User, Post, Category) # I have users and reviews.
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts) # user has many reviews.
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User) # review belongs to a user.
- [x] Include user accounts with unique login attribute (username or email) # user.rb validates uniqueness of both username and email.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying # reviews can do everything CRUD.
- [x] Ensure that users can't modify content created by other users # other users can't edit anyone else's reviews.
- [x] Include user input validations
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new) # error messages shown
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code # readme includes all of these.

Confirm
- [x] You have a large number of small Git commits # Correct
- [x] Your commit messages are meaningful # They relate to the work I have done.
- [x] You made the changes in a commit that relate to the commit message # Correct
- [x] You don't include changes in a commit that aren't related to the commit message # Correct