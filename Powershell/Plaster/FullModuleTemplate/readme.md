# <%= $PLASTER_PARAM_ModuleName %>

<%= $PLASTER_PARAM_ModuleDesc %>

[![Build status](https://ci.appveyor.com/api/projects/status/github/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_ModuleDesc %>?branch=master&svg=true)](https://ci.appveyor.com/project/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_ModuleDesc %>)
[![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/<%= $PLASTER_PARAM_ModuleDesc %>/)
[![Coverage Status](https://coveralls.io/repos/github/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_ModuleDesc %>/badge.svg?branch=master)](https://coveralls.io/github/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_ModuleDesc %>?branch=master)
[![Documentation Status](https://img.shields.io/badge/docs-latest-brightgreen.svg?style=flat)](http://<%= $PLASTER_PARAM_ModuleDesc %>.readthedocs.io/en/latest/?badge=latest)

## GitPitch PitchMe presentation

* [gitpitch.com/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_GitHubRepo %>](https://gitpitch.com/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_GitHubRepo %>)

## Getting Started

Install from the PSGallery and Import the module

    Install-Module <%= $PLASTER_PARAM_ModuleName %>
    Import-Module <%= $PLASTER_PARAM_ModuleName %>


## More Information

For more information

* [<%= $PLASTER_PARAM_ModuleName %>.readthedocs.io](http://<%= $PLASTER_PARAM_ModuleName %>.readthedocs.io)
* [github.com/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_GitHubRepo %>](https://github.com/<%= $PLASTER_PARAM_GitHubUserName %>/<%= $PLASTER_PARAM_GitHubRepo %>)
* [<%= $PLASTER_PARAM_GitHubUserName %>.github.io](https://<%= $PLASTER_PARAM_GitHubUserName %>.github.io)


This project was generated using [Kevin Marquette](http://kevinmarquette.github.io)'s [Full Module Plaster Template](https://github.com/KevinMarquette/PlasterTemplates/tree/master/FullModuleTemplate).