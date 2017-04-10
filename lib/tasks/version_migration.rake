# The purpose of this task is to convert from version 1.x to version 2.x. This to be run after the database changes have been fully migrating.

# Create new company name: JMR Mathematics, subdomain: columbus
# Skip schema creation

Company.skip_callback(:create, :after, :create_schema)

Company.create!(name: 'JMR Mathematics', subdomain: 'columbus')

Company.set_callback(:create, :after, :create_schema)

# Flag achievements with attendance/ assignment etc.

# Student attributes

students = Student.all
