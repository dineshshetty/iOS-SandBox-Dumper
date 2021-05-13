During an iOS pentesting gig you'll need to:
- Take a look at the data that is being stored in the application sandbox
- Analyze the application binary

The location of the application binary is /private/var/mobile/containers/Bundle/Application/\<Bundle\-GUID\>/

The location of the application data directory is /private/var/containers/Data/Application/\<App\-GUID\>/

These GUID values bear no indication of which application they belong to. You'll end up spending quite some time trying to figure out these GUID values every time you reinstall the application.

SandBox-Dumper makes use of multiple private libraries to provide exact locations of the application sandbox, application bundle and some other interesting information. It should work on all the latest iOS versions. (Confirmed to be working on jailbroken iOS 14.2 device)

<img src="https://i.imgur.com/QyMu3Z5.png" height="400" width="300" >

ToDo:
Option to switch between User and System applications
