# Monitored Task Execution
This project enables performing a number of actions while recording pertinent information about the actions performed

## Usage
### Running Executable Processes
To create a file: `ruby bin/monitor.rb execute "COMMAND"`

where COMMAND is the executable command to run, with all necessary arguments

### Manipulating Files
To create a file: `ruby bin/monitor.rb file create [FILENAME]`

To delete a file: `ruby bin/monitor.rb file delete [FILENAME]`

To append to a file: `ruby bin/monitor.rb file apend [FILENAME] "CONTENT"`

where FILENAME is the local or absolute file path, and CONTENT is the data to append

### Making HTTP calls
To make a get call: `ruby bin/monitor.rb connection get [ADDRESS]`

To make a post call: `ruby bin/monitor.rb connection post [ADDRESS] 'PAYLOAD'`

where ADDRESS is the full url and PAYLOAD is the data to post

Content-Type can be specified with the switch `--content-type`

## Design Decisions
Given the set of actions to perform and the development timeline, a command line utility seemed like the best approach.
This allows the Thor gem to do the heavy lifting on UI, without requiring too much development. Because of the choice of interface,
certain data were easier to collect, such as username, as that an authentication system did not need to be developed for the project.
I decided to attempt to have all actions be performed as command line programs, rather than ruby classes, to use the operating system's
authentication and file ownership systems to ensure actions performed were permitted, without having to establish credntials.
Surprisingly, this only caused friction in two spots, as that creating and deleting files are different commands in linux and Windows.

The activity data is being logged in a yml file, with only the relevant fields for each action type. Each new record is
directly appended onto the file, to keep from incurring performance costs of holding the data in memory as the size grows.

## Refactoring Opportunities & Known Issues
As of currently, the code for logging activity co-habitates with the code for performing the actions, and both of them are
coupled with the runner method of Thor actions. This would be a high value refactor, making it easier to change how or where logs are recorded
as well as the strategy for performing different actions. The code would also likely be able to be simplified, where
some data being logged is identical between different tasks.

It's also important to note that the software currently assumes proficient, non-malicious users, as that putting user input directly into
the command line is hazardous at best.

## Lessons Learned
I had not used the gem thor before this project, and as always, I find that testing a new tool is much higher complexity than
using a new tool in the first place. 