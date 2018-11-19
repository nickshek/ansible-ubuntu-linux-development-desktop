#!/bin/bash
sudo su -c "grep -q -F '$USER ALL=(ALL) NOPASSWD: ALL' /etc/sudoers" || sudo su -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
