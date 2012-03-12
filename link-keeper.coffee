#!/usr/bin/env coffee
program = require('commander')
_ = require('underscore')

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
    path = path || "./"
    database = options.database || "json"
    browser = options.browser || "/usr/bin/google-chrome"
  )

# $ ls [tag]
# $ list [tag]
list_links = (tag = "All") ->
  links = require('./lib/links').links
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

program
  .command('ls [tag]')
  .description('Lists links stored in link-keeper')
  .action(list_link_action)

program
  .command('list [tag]')
  .description('Lists links stored in link-keeper')
  .action(list_link_action)

program.parse(process.argv)
