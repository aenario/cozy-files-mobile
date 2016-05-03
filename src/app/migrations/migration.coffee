async = require 'async'
semver = require 'semver'
log = require('../lib/persistent_log')
    prefix: "Filter Manager"
    date: true


# corresponding of migration file
migrations = [
    '1.2.0'
    '1.1.1'
    '1.0.0'
    '0.3.0'
]


module.exports =


    migrate: (oldVersion, callback) ->
        log.debug 'migrate'

        migrationsSorted = migrations.sort (a, b) -> semver.compare a, b
        config = app.init.config

        async.eachSeries migrationsSorted, (version, cb) ->
            if semver.gt(version, oldVersion)
                log.debug "migration #{version}"

                migration = require "./#{version}"
                migration.migrate (err) ->
                    log.warn err if err
                    config.set 'appVersion', version, cb
            else
                cb()
        , ->
            config.updateVersion callback
