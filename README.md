[![Build status](https://ci.appveyor.com/api/projects/status/si40sx6k2lkfc7w0?svg=true)](https://ci.appveyor.com/project/anupkumarsharma/jinga)


Jinga
=======
Jinga pronounced as Zynga provides a solution to handle the **file transformations using simple YAML file as input**. 
YAML provides the best way to maintain different variables and maintain values of those, for a different type of environment or setting.
Variables can be defined to be substituted by any of the following mechanism.
*String Replacement
*XPath Replacement
*Regex Replacement 

 

Developer Scenario 
-------------
Developers often work with configuration files locally like web.config, app.config  and during build/release process, these files need to be transformed as per the environment values.
This becomes a tedious process for continuous integration. Idea is to replace this step with a simple script, which can handle the substitutions of the variable at any point in time 
and can transform the file with correct values. 

A Jinga Invocation
-------------
```powershell

Invoke-Jinga  $yamlFilepath $backupfilePath 'development' 

YAML Configuration
-------------
```YAML
Configuration:
 - Define:
    TypeXpath: 
      host:  /file/foo[@attribute='bar']/@attribute
    TypeRegEx: 
      regexpression:  '\.\d{2}\.'
 - RuleSet:
    File: 'web.config'
    Substitute:
     development:
      database: myapp_development
      adapter:  postgres
      host:     AnupHost
      regexpression: 10
     test:
      database: myapp_test
      adapter:  postgres
      host:     localhost
 - RuleSet:
    File: 'app.txt'
    Substitute:
     development:
      database: myapp_development
      adapter:  postgres
      host:     localhost
      regexpression: 1010
     test:
      database: myapp_test
      adapter:  postgres
      host:     localhost

This is still in active development and stable release will be out by Jan 2017

