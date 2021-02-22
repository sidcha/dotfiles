Setup:

mutt - Mail reader
mbsync - IMAP mailbox manager
msmtp - Send mail client

```
brew install isync msmtp mutt
mkdir ~/Mail/
mkdir ~/Mail/Accounts
echo set sendmail="/usr/local/bin/msmtp" > ~/.mailrc
ln -s ~/.files/runcon/mutt/ ~/Mail/Accounts/config
ln -s ~/files/runcon/mutt/global.muttrc ~/.muttrc
```
