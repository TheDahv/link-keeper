#!/usr/bin/env coffee

program = require('commander')
exec = require('child_process').exec
fs = require('fs')
_ = require('underscore')
Table = require('cli-table')

# Prepare the link data to have
# sequential IDs when the program loads
load_links = () ->
  id_index = 1
  links = require('./lib/links')
  _.chain(links)
    .map((link) ->
      link.id = id_index
      id_index += 1

      link
    )
    .value()

links = load_links()

conf = require('./lib/conf')

mega_fail = (err) ->
  console.error(err)
  process.exit(1)

program.version('0.0.1')

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

group_tags = () ->
  _.chain(links).
    map((link) -> link.tags).
    flatten().
    uniq().
    map((tag) ->
      counted_tag = 
        tag: tag
        count: _.filter(links, (link) -> _.include(link.tags, tag)).length
      counted_tag
    ).
    sortBy((counted_tag) -> counted_tag.count).
    reverse().
    value()

list_tag_action = () ->
  args = 
    head: ['Tag', 'Count']
    colWidths: [15, 10]
    colAligns: ['left', 'right']
  table = new Table(args)
  _.each(group_tags(), (group) -> table.push([group.tag, group.count]))
  console.log(table.toString())

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
  if tag == "All"
    chained_links = _.chain(links)
  else
    chained_links = _.chain(links).filter((link) -> _.include(link.tags, tag))

  chained_links.value()

list_link_action = (tag) -> 
  links = list_links(tag)
  args = 
    head: ['Link Id', 'Tags', 'Url', 'Nick']
    colWidths: [10, 40, 60, 15]
  table = new Table(args)

  _.each(links, (link) -> 
    table.push([link.id, link.tags.join(", "), link.url, link.nick])
  )

  console.log(table.toString())

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

# $ cp [link_id]
# $ cp [--nick]
# $ copy [link_id]
# $ copy [--nick]
copy_description = 'Copies the specified link into the system clipboard'
copy_link_action = (link_id, options) ->
  console.log('NOTHING IMPLEMENTED YET STOP TRYING TO DO THIS')

program
  .command('cp [link_id]')
  .description(copy_description)
  .option('-n, --nick [nick]', 'The nickname of the link to launch')
  .action(copy_link_action)

program
  .command('copy [link_id]')
  .description(copy_description)
  .option('-n, --nick [nick]', 'The nickname of the link to launch')
  .action(copy_link_action)

# $ launch [link_id]
# $ launch [--nick]
program
  .command('launch [link_id]')
  .description('Launches the specified link in a browser')
  .option('-n, --nick [nick]', 'The nickname of the link to launch')
  .action((link_id, options) ->
    nick = options.nick
    id = parseInt(link_id, 10)
    
    if nick
      filter_fn = (l) -> l.nick == nick
    else
      filter_fn = (l) -> l.id == id

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
