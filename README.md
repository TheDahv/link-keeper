#Link-Keeper
Link-Keeper is a command line tool to help you keep links you want to read later

I just remembered this is similar to [Zach Holman's](https://twitter.com/#!/holman) 
[Boom](http://zachholman.com/boom/) project. I think that solves the Ruby vs Node.js
debate for me. Since this idea has been done in Ruby, I'm going to do it in Node.js.

This project is strictly about keeping my open tab count low so I don't feel bad about
life. Boom seems like a cool project too, so I won't be sad if you think that suits your 
needs better.

##Why
I hate having too many tabs at once. Tools like like 
[Read Later Fast](https://chrome.google.com/webstore/detail/decdfngdidijkdjgbknlnepdljfaepji)
are great for stashing away URLs to read later. So are favorites in a browser.

Even though there are existing solutions, I want a new tool that:

* I can use on the command line.
* Is well organized.
* Keeps a local and permanent copy of links I like.
* I create myself. This is a fun learning project for me!

##Installation
I haven't decided what language to write this in yet. I don't know.

##Usage
None of this actually exists yet. Think of this as 
'[README driven development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html).'

###Initialize
`link-keeper init [path] [--database] [--browser]`

Initializes a new link-keeper set up in the specified path. If no path is given,
link-keeper will create a 'link-keeper' folder in the current directory and install
itself there.

* `--database` - The default will just be a JSON file, but link-keeper could be
configured to store your links in mongodb or whatever I feel like getting around
to doing.
* `--browser` - The default browser to launch links will probably be Chrome, but
might need to specify a browser it can use to launch your links for you.

###Show commands
`link-keeper`

Lists all the things link-keeper can do

###List links
`link-keeper ls [tag]`

`link-keeper list [tag]`

Lists all the links stored in link-keeper. If a tag is specified, link-keeper will
grab all links with that tag.

###Add link
`link-keeper add [tag] [url] [--nick]`

Add a link to the data store under the specified tag. If no tag is provided, link-keeper
will assume you hate organizing your things and will stick it in an 'Misc' group.

There are likely some links that you use often enough that you can give them a nickname.

For example, I pull up [ScriptSrc.net](http://www.scriptsrc.net/) often enough to wish
I had the URL memorized, but not enough that it makes it into my bookmarks (again, I don't
like to crowd up my browser pixels). Instead, I could store the link with the nickname
`script-src` and be happy all the rest of my days.

Now you can use link-keeper commands with the nickname you've memorized to pull these
URLs out quickly.

###Copy link
`link-keeper cp [link-id]`

`link-keeper cp [link-nick]`

`link-keeper copy [link-id]`

`link-keeper copy [link-nick]`

Once you find the link you want, link-keeper can copy the URL into your
clipboard to paste in an IRC channel or copy into the browser. Whatever it is
you do with links.

This also understands link nicks for those links you use regularly.

###Launch link
`link-keeper launch [link-id]`

Launching a link in a browser is likely a common enough activity that it should
have its own command. This will launch the specified link in whatever browser you
specified when you initiated link-keeper.

###Edit links
`link-keeper edit [link-id] [--tag] [--nick] [--url]`

`link-keeper edit [link-nick] [--tag] [--nick] [--url]`

Useful if you want to add a nick or change the tag on a URL.

###Delete links
`link-keeper rm [link-id]`

`link-keeper rm [link-nick]`

`link-keeper delete [link-id]`

`link-keeper delete [link-nick]`

Removes a link entry from the datastore.

##Contributing
Pull requests with working tests are welcome. 
I would get the most help from you suggesting new 
ideas or pointing out bugs in the issues section.
