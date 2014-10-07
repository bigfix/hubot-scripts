Secrets
-------

*Do not put any secret information in any scripts!*

If you need to use a password, an API key, or any other secret in your
script, make it an environment variable referenced by the script instead. Do
not write the secret into the script!

When you want to deploy a script with a secret, ask Mike Ottum or Brian Green
to add the environment variable to the production hubot instance.

See [bugzilla.coffee](scripts/bugzilla.coffee) for an example.

Setup
-----

To create the Hubot test environment, you'll need
[vagrant](http://www.vagrantup.com/) and
[VirtualBox](https://www.virtualbox.org/).

First, clone this repo:

    $ git clone git@github.com:bigfix/hubot-scripts.git
    $ cd hubot-scripts

Then install all the node modules we use:

    $ npm install

Next, start the virtual machine for hubot:

    $ vagrant up

Once the vagrant box has finished installing everything, ssh into it with:

    $ vagrant ssh

Or if you're on Windows, you can use putty to ssh to `127.0.0.1:2222` with user
`vagrant` and password `vagrant`.

Once you've ssh'd into the vagrant box, you can run Hubot with:

    $ cd hubot
    $ bin/hubot

You should then be able to run any Hubot command:

    Hubot> hubot ping
    Hubot> PONG

Adding a new script
-------------------

First read the Hubot [documentation on creating scripts](https://github.com/github/hubot/blob/master/docs/scripting.md).

To add a new script, create a new `.js` or `.coffee` file in the
`scripts` directory. The script will get loaded when Hubot starts up.

Deploying your script
---------------------

Once you've tested your script and you're ready to deploy it, commit it to
github.

To ask Hubot to sync itself with github, say `hubot sync` in the irc channel.
