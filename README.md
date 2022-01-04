# luxafor

Forked from WilliamDurin/luxafor in order to make his very useful script working again with MacOs Monterey.

The old DND detection API has changed with Big Sur. A new approach is to run shell commands in order to get the DND status: https://gist.github.com/a7madgamal/9d3518a62c21477a92be461fbd652533
Substituted the old DND checker from WilliamDurin's repository with a short (hacky) shell script to address this change. 


This is just a repo I setup to help me manage my luxaflor flag/git status. It is completely unsupported, as it's mostly just here for my own use.

Workflow:
* If I put do not disturb mode on my mac: set dnd on slack, set slack status, turn flag red
* If I'm in a Zoom meeting, set slack status, turn flag red
* If I'm in a Slack meeting, set slack status, turn flag red
* When these conditions clear, turn flag green, reset slack status


## Setup

```bash
brew install go # Install go in order to be able to run the next step
go get -v -u github.com/leosunmo/goluxafor/example/luxcli # control lux flag
brew install rockymadden/rockymadden/slack-cli # talk to Slack
brew install supervisor # Run script as service
brew services start supervisor
mkdir /usr/local/etc/slack-cli
mkdir -p /usr/local/etc/supervisor.d/
sudo /usr/bin/pip3 install pyobjc-framework-Quartz
slack init
```

Place this repository's content in /Users/[username]/luxafor and edit
/usr/local/etc/supervisor.d/luxafor.ini contents (replace [username] with your macOS user name)

```
[program:luxafor]
directory=/Users/[username]/luxafor
command=/Users/[username]/luxafor/lux.sh
startsecs=0
user=[username]
autorestart=true
environment= PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/[username]/.go/bin"
stdout_logfile=/Users/[username]/workspace/luxafor/lux.log
stderr_logfile=/Users/[username]/workspace/luxafor/lux_error.log
```
In order to apply config changes run
```
brew services restart supervisor
```
