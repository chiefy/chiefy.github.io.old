---
layout: post
title: "Using Sails Generators To Integrate An Ember-cli Project"
date: 2014-08-25 18:00:00
tags: 
  - sails
  - generators
  - javascript
  - ember
  - ember-cli
---

Recently I have been trying to learn Ember and I came across the amazing command line utility `ember-cli` written by Stefan Penner. `ember-cli` is the missing utility belt for ember based projects. Among its' features is a generator that creates a strongly opinionated project structure and build chain. Ember-cli uses an ES6 module transpiler allowing users to use next-gen ES6 module support in their current projects today. It also utilizes `brocolli` for build tooling as opposed to `grunt` which Sails seems to favor. More on that later.

Along with ember-cli, I ran across [sails-ember-blueprints](https://github.com/mphasize/sails-ember-blueprints) by [mphasize](https://github.com/mphasize) which overrides some of Sails' blueprint templates for compatibility with Ember Data's `RESTAdapter`.

I decided to take a stab at creating some Sails generators around these great projects.

## Getting Started

In order to get started, you will need to make sure you have the latest Sails, ember-cli and sails-generate-new-ember:
{% highlight bash %}
$ npm install -g sails ember-cli sails-generate-new-ember sails-generate-frontend-ember sails-generate-backend-ember
{% endhighlight %}

To use the newly installed generator, you will need to modify (or create) your `.sailsrc` located in your home folder. Sails allows you to override it's built-in generators for creating a new application. So in theory you could:

{% highlight javascript %}
{
    "generators" : {
        "modules" : {
            "new" : "sails-generate-new-ember"
        }
    }
}
{% endhighlight %}

The issue with that, especially if you save your `.sailsrc` in your home folder, is that everytime you call `sails new` it will use the ember-based generators. I have a feeling that you probably won't want that, so instead, you should create a `.sailsrc` that uses an alternate module name:

{% highlight javascript %}
{
    "generators" : {
        "modules" : {
            "ember-app" : "sails-generate-new-ember"
        }
    }
}
{% endhighlight %}

Finally, we can create our new project by invoking Sails' command line.
{% highlight bash %}
$ sails generate ember-app myAwesomeApp
{% endhighlight %}

## Project Structure
If you are familiar with the default `sails new <app-name>` generator and it's resulting project structure, you will find some large differences here. The first thing to note is that there is no `assets` folder. Instead, there is an `ember` folder which is where all of the `ember-cli` based project structure resides. Since `ember-cli` uses `brocolli` for tooling, I've decided to remove the `Gruntfile.js` and `tasks` folder for the time being as all of the frontend build is being done by `ember serve`.

#### Sails Blueprints
I've taken the `sails-ember-blueprints` project code and inserted it into the `sails-generate-backend-ember` step of the generator. The blueprints reside in the `api/blueprints` folder, they modify Sails' response output to achieve compatibility with Ember Data's [`RESTAdapter`](http://emberjs.com/api/data/classes/DS.RESTAdapter.html). Many thanks to GitHub user [mphasize](https://github.com/mphasize) for this project as I am sure it saved me a ton of time and effort.

#### Uchk! Brocolli! (Caveats)
When I was developing this generator I was thinking it would be a great opportunity to try to use `brocolli` for building out the frontend and serving it with `sails lift`. Unfortunately, after looking into some of the code in `ember-cli`, it's not as easy as I had hoped. Both `sails lift` and `ember serve` try to serve using their own instances of express. `ember serve` uses `brocolli` under the hood to do a lot when watching templates and files in the `ember` project. I have mostly unsuccesfully tried to bootstrap both of these processes in the project's main `app.js` file, which you can run with `node app.js`, but you will see both commands try to use the output stream asynchronously and it results in a confusing jumble of console output. 

## Fire It Up!
For now, during development, you will need to start up two seperate servers: your Sails API server which will serve your JSON API (port 1337), and ember-cli's server which will serve up the proper client application html / js / css (port 4200). As you will see when you point your browser to `http://localhost:4200/`, there is nothing really to show as we haven't created any of our frontend (or backend) project. I recommend opening two console tabs and executing one of these commands in each.
{% highlight bash %}
$ sails lift
{% endhighlight %}99
{% highlight bash %}
$ cd ember && ember serve
{% endhighlight %}
