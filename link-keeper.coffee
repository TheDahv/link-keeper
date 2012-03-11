#!/usr/bin/env coffee
program = require('commander')

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
    path = path || "./link-keeper"
    database = options.database || "json"
    browser = options.browser || "/usr/bin/google-chrome"

    console.log(path)
    console.log(database)
    console.log(browser)
  )

program.parse(process.argv)
