#!/usr/bin/env coffee
program = require('commander')
exec = require('child_process').exec
fs = require('fs')
_ = require('underscore')

links = require('./lib/links')
conf = require('./lib/conf')

mega_fail = (err) ->
  console.error(err)
  process.exit(1)

program
  .version('0.0.1')
  .parse(process.argv)

# $ init [path]
program
  .command('init [path]')
  .description('Initializes link-keeper in the given location')
  .option('-d, --database [database]', 'The link-keeper datastore')
  .option('-b, --browser [browser]', 'The default browser to launch links')
  .action((path, options) -> 
    # Nothing implemented yet
    path = path || "./"
    database = options.database || "json"
    browser = options.browser || "/usr/bin/google-chrome"
  )

# $ ls-tags
# $ list-tags
list_tag_description = 'Lists all the tags link-keeper knows about.'
list_tag_action = () ->
  _.chain(links)
    .map((link) -> link.tags)
    .flatten()
    .uniq()
    .map((tag) ->
      counted_tag = 
        tag: tag
        count: _.filter(links, (link) -> _.include(link.tags, tag)).length
      counted_tag
    )
    .sortBy((counted_tag) -> counted_tag.count)
    .reverse()
    .each((counted_tag) -> 
      console.log("%s - %d", counted_tag.tag, counted_tag.count)
    )

program
  .command('ls-tags')
  .description(list_tag_description)
  .action(list_tag_action)

program
  .command('list-tags')
  .description(list_tag_description)
  .action(list_tag_action)

# $ ls [tag]
# $ list [tag]
list_links = (tag = "All") ->
  chained_links

  if tag == "All"
    chained_links = _.chain(links)
  else
    chained_links = _.chain(links).filter((link) -> _.include(link.tags, tag))

  chained_links.map((link) -> link.url).value()

list_link_action = (tag) -> 
  links = list_links(tag)
  _.each(links, (t) -> 
    console.log(t)
  )

list_link_description = 'Lists links stored in link-keeper'

program
  .command('ls [tag]')
  .description(list_link_description)
  .action(list_link_action)

program
  .command('list [tag]')
  .description(list_link_description)
  .action(list_link_action)

# $ add [tag] [url] --nick
program
  .command('add [url]')
  .description('Add a link to the datastore under the specified tags')
  .option('-t, --tags [tags]', 'The comma-separated tags to store with the link')
  .option('-n, --nick [nick]', 'The nick to assign to the link (optional)')
  .action((url, options) ->
    nick = ""
    tags = []

    if options.tags
      tags = options.tags.split(',')
    else
      tags = ["misc"]
  
    new_link = 
      url: url
      tags: tags
      nick: nick

    links.push(new_link)

    fs.writeFile('./lib/links.json', JSON.stringify(links), (err) ->
      mega_fail(err) if err
      console.log('link added!')
    )
  )

# $ launch [link_id]
# $ launch [--nick]
program
  .command('launch [link_id]')
  .description('Launches the specified link in a browser')
  .option('-n, --nick [nick]', 'The nickname of the link to launch')
  .action((link_id, options) ->
    url = ""
    nick = options.nick
    
    if nick
      filter_fn = (l) -> l.nick == nick
    else
      filter_fn = (l) -> l.id == link_id

    requested_link = _.find(links, filter_fn)
    url = requested_link.url if requested_link

    if url
      exec(conf.browser + ' ' + url, (err, stdout, stderr) -> 
        mega_fail(err) if (err)

        console.log('link launched')
        console.log(stdout)
      ) 
    else
      mega_fail("Unable to find that link!")

  )
program.parse(process.argv)
