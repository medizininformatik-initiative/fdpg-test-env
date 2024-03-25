Role Name
=========

Setup and start test data management site (DMS).

Requirements
------------

The dns entry for the domain defined by the group variable `dms_fhir_domain` must be set and the host be created by terraform.

Role Variables
--------------

None

Dependencies
------------

The dns entry for the domain defined by the group variable `dms_fhir_domain` must be set and the host be created by terraform.

Example Playbook
----------------

    - hosts: servers
      roles:
      - dms

License
-------

BSD

