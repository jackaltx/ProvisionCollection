Role Name
=========


Gitea is a self-hosted software development service that includes: Git hosting, Code review, Team collaboration, Package registry, CI/CD, Bug tracking, Kanban boards, Tickets, and Wikis. 

Gitea is similar to GitHub, Bitbucket, and GitLab. It's written in Go and can be hosted on Linux, macOS, and Windows. Gitea is designed to be: lightweight, easy to use, and highly customizable


Requirements
------------

none

Role Variables
--------------

it just installs with a default configuration.  Manual setup.

Dependencies
------------

none

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: gitea
      roles:
         - { gitea: username.rolename, x: 42 }

License
-------

MIT

Author Information
------------------

Jack wrote