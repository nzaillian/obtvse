Codename: Obtvse
================
Clean, simple blog.  Inspired by [Svbtle](http://svbtle.com).

About This Fork (nzaillian/obtvse)
==================================
This fork of the Obtvse blogging platform adds support for multiple user accounts and multiple blogs.  Furthermore, basic configuration of each blog can, in this fork, be accomplished from within the browser via admin forms (in the upstream project, users must edit a configuration file to accomplish the same).

**Demo**

http://obtvse.herokuapp.com

http://obtvse.herokuapp.com/admin

Username: username
Password: password

Installation
============

    git clone git://github.com/NateW/obtvse.git
    cd obtvse
    bundle install
    rake db:migrate

Edit settings config/config.yml.  Be sure to set your username and password.


Start the local server:

    rails s

Go to [0.0.0.0:3000](http://0.0.0.0:3000/)
Go to [0.0.0.0:3000/admin](http://0.0.0.0:3000/admin)


TODO
====
- Easy deployment
- Draft preview and post save history
- Caching
- Refine!


SCREENSHOTS
===========
![Admin](http://i.imgur.com/OVr7q.png)
![New](http://i.imgur.com/MTm2c.png)
![Edit](http://i.imgur.com/VSR7M.png)