# Roles

Roles is an extremely simple roles gem inspired by [rolify](https://github.com/EppO/rolify).

This library is recommended to be used with [CanCan](https://github.com/ryanb/cancan) and [devise](https://github.com/plataformatec/devise).

## Why Roles

Look at this discussion: [comment](https://github.com/EppO/rolify/issues/80#issuecomment-7790341)

In a word, Rolify uses two tables `roles` and `users_roles` while Roles only uses one table `roles`.

## Quick Start

```ruby

# query roles
user.has_role?(:admin)  # if user is admin globally
user.has_role?(:admin, Organization)  # if user is admin for Organization type
user.has_role?(:admin, Organization.first) # if user is not admin of the first organization
user.role_names(instance = nil) # => returns role names of current user, optionally scoped by Class, instance or non-scoped(globally)

# grant roles
user.add_role(:admin) # a global admin
user.add_role(:admin, Organization) # admin for type Organization
user.add_role(:admin, Organization.first) #  admin for the first organization

# revoke roles
user.remove_role(:admin) # remove global admin
user.remove_role(:admin, Organization) # remove admin for type Organization
user.remove_role(:admin, Organization.first) # remove admin for the first organization

# global role DON'T overrides resource role request
user = User.find(4)
user.add_role :moderator # sets a global role
user.has_role? :moderator, Forum # => false
user.add_role :moderator, Forum # sets a role on resource type
user.has_role? :moderator, Forum.first # => false
user.has_role? :moderator, Forum.last  # => false

# query about users
Forum.users_with_role(role = nil) # => returns all users with roles defined on Forum
forum.users_with_role(role = nil) # => returns users with a role defined of current instance
User.with_role(role, resource = nil) # => returns all users with the given role, optionally scoped by Class, instance or non-scoped(globally)

# query about resources
user.resources_with_role(Project, role_name = nil)
# => returns all projects for a given user, optionally filtered by role_name.
```

## Requirements

* Rails >= 3.1
* ActiveRecord >= 3.1
* supports ruby 1.9

## Installation

Add this to your Gemfile and run the +bundle+ command.

```ruby
  gem "roles"
```

## Getting Started

### 1. Generate Role Model

First, create your Role model and migration file using this generator:

```
  rails g roles:role Role User
```

Role and User classes are the default.

### 2. Run the migration

```
  rake db:migrate
```

### 3.1 Configure your user model

This gem adds the `rolify` method to your User class.

```ruby
  class User < ActiveRecord::Base
    rolify
  end
```

### 3.2 Configure your resource models

In the resource models you want to apply roles on, just add ``resourcify`` method.
For example, on this ActiveRecord class:

```ruby
class Forum < ActiveRecord::Base
  resourcify
end
```

## Resources

* [Rolify](https://github.com/EppO/rolify)
* [CanCan](https://github.com/ryanb/cancan)
* [Amazing tutorial](http://railsapps.github.com/tutorial-rails-bootstrap-devise-cancan.html) provided by [RailsApps](http://railsapps.github.com/)

