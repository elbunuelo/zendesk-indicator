#! /bin/bash

cd "$(dirname "$0")"
[ -f $HOME/.zendesk ] && source $HOME/.zendesk
bundle exec ruby ./zendesk.rb
