Hubot-tabetai
=============

Hubot-tabetai is a chat-based event participants manager, especially for pizza party.

## Requirement
* Node.js
* Hubot

## Usage
### hubot tabetai open (your favoriate food)
Open command creates new tabetai and joins you in it.  
![hubot tabetai open :pizza:](https://gyazo.com/1f0382ed083a71e21ed54b6c77d8405a.png)
### hubot tabetai join (existing tabetai)
Join command joins you in specified tabetai.  
![hubot tabetai join :pizza:](https://gyazo.com/547d306c07eda4da63341372a07990a5.png)
### hubot tabetai cancel (existing tabetai)
Cancel command removes you from specified tabetai.  
![hubot tabetai cancel :pizza:](https://gyazo.com/832a7eb79bdaab14f182df4e35af72a1.png)
### hubot tabetai close (existing tabetai)
Close command closes specified tabetai and show the members in it.  
![hubot tabetai close :pizza:](https://gyazo.com/e38a82c3faafa654e428b7ab6daf88da.png)
### hubot tabetai list
List command shows living(not closed yet) tabetaies and the active tabetai.  
![hubot tabetai list](https://gyazo.com/df48e01189f100a9e83b4d24030a6fd5.png)
### hubot tabetai members (existing tabetai)
Members command shows the members in specified tabetai.  
![hubot tabetai members :pizza:](https://gyazo.com/1df42946238e0fd6ffde3ba396547c34.png)
### hubot tabetai invite (other members) (existing tabetai)
Invite command invites specified members to tabetai.  
![hubot tabetai invite Java C C++ :pizza:](https://gyazo.com/3373d932d5fd1808e132b83f44db0aa1.png)
### hubot tabetai kick (other members) (existing tabetai)
Kick command removes specified members from tabetai.  
![hubot tabetai kick Java C :pizza:](https://gyazo.com/abd31ed509159503401953609ae7af73.png)

The shorthand of tabetai commands is also available: "ku."

### hubot ku (new tabetai)
is equal to `hubot tabetai open (new tabetai)`.  
![hubot ku :pizza: (when :pizza: is a new tabetai)](https://gyazo.com/0a5ead82741ed071a19f3ef696b08f9a.png)
### hubot ku (existing tabetai)
is equal to `hubot tabetai join (existing tabetai)`.  
![hubot ku :pizza: (when there were already :pizza:)](https://gyazo.com/4ab4452680354557b47416221fda7572.png)
### hubot ku
is equal to `hubot tabetai join (active tabetai)`.  
![hubot ku](https://gyazo.com/90c8ad35039d6cef89ad51f7dfe4d660.png)

### Active tabetai
Active tabetai is the newest tabetai. When you bless `hubot ku`, you join the active tabetai.
Join, open, and ku commands change the active tabetai.

## Contribution
Pull request is welcome. Create new branch from develop to add a new feature.

When you find bugs with hubot-tabetai, please make new issue, or create new branch from master and send a PR to master.
