#!/usr/bin/env coffee
program = require('commander')
_ = require('underscore')
links = require('./lib/links').links

program
  .version('0.0.1')
  .parse(process.argv)

# $ init [path]
program
  .command('init [path]')
  .description('Initializes link-keeper in the given location')
  .option('-d, --database [db]', 'The link-keeper datastore')
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
    .sortBy((tag) -> tag)
    .each((tag) -> console.log(tag))

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

program.parse(process.argv)
