#What's in the software?

"Docksal" is an umbrella for all the components and services you get. It uses Docker to manage containers and Docker Compose to
manage the configurations, so almost anything you can do with Docker you can do with Docksal. There are also a number of 
containers managed by the Docksal team that are tuned for Docksal's most common use case, which is Drupal/PHP CMS development.

And along with this comes predefined ["stacks"](/stack-config/#default-configurations) that quickly and easily setup projects for you so you don't have
understand all the complexity in configuring containers. Docksal's main purpose is to make managing projects **easy**. We try to take care of most of the work for you,
so you focus on your project.

For those of you that are a little more particular about how you setup your projects, don't fret. You can choose to use your own, or any other, containers,
and setup the configurations how ever you like. Docksal's predefined services are provided to make things easy for anyone that doesn't know, or doesn't want to know,
how to manage it themselves.

With Docksal you also get `fin`, the command line tool used to manage your projects. Fin has builtin in commands for every day tasks, like 
stopping and starting services, importing and exporting databases, initializing projects, executing bash commands inside the containers, and adding ssh keys.
Fin is also easily extended with custom commands that can be universal to your computer, or unique for each project.
