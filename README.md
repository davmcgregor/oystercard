### [Makers Academy](http://www.makersacademy.com) - Week 2 Pair Programming Project

# Oyster card 

| [Task](#Task) | [Installation Instructions](#Installation) | [Feature Tests](#Feature_Tests) | [User Stories](#Story) | [Objects & Methods](#Methods) | [Testing](#Testing) | [Further improvements](#Further_Improvements)

![oystercard](oystercard.jpeg)

## <a name="Task">Task</a>

Replicate the London metro Oyster Card system based on the below user stories. Build on the Object Oriented Programming principles used in week 1 to improve knowledge of Ruby and TDD.   

This challenge is the second pair programming challenge at [Makers Academy](https://github.com/makersacademy)

## <a name="Installation">Installation Instructions</a>

1. Fork this repository, clone to your local machine then change into the directory:
```
$ git clone git@github.com:davmcgregor/oystercard.git
$ cd oystercard
```
2. Load dependencies with bundle:
```
$ gem install bundle
$ bundle
```
3. Run the app in the terminal:

```Shell
$ irb
> require './lib/oystercard_challenge.rb'
```

## <a name="Feature_Tests">Feature Tests (How it works)</a>

```
> card = Oystercard.new
> card
 => #<Oystercard:0x00007fac7618a7c0 @balance=0, @journey_log=#<JourneyLog:0x00007fac7618a748 @in_journey=false, @journey_log=[], @journey_class=Journey>> 
```
Oystercards can be made an a new instance of the Oystercard class.
```
> entry_station = Station.new("Angel", 1)
> exit_station = Station.new("Aldgate East", 1)
> card.touch_in(entry_station)
RuntimeError (Balance not high enough for journey)
```
Oyster cards need a minimum balance in order to make a journey.
```
card.top_up(50)
=> 50 
```
To put money on an Oyster card use top_up and pass in a desired amount as an argument.
```
> card.touch_out(exit_station)
=> 49 
```
Journeys will deduct fares from an Oyster card balance
```
> card.top_up(50)
RuntimeError (Maximum balance of 90 exceeded)
```
Topping up past the maximum balance will raise an error

## <a name="Story">User Stories</a>

```
In order to use public transport
As a customer
I want money on my card
```
```
In order to keep using public transport
As a customer
I want to add money to my card
```
```
In order to protect my money
As a customer
I don't want to put too much money on my card
```
```
In order to pay for my journey
As a customer
I need my fare deducted from my card
```
```
In order to get through the barriers
As a customer
I need to touch in and out
```
```
In order to pay for my journey
As a customer
I need to have the minimum amount for a single journey
```
```
In order to pay for my journey
As a customer
I need to pay for my journey when it's complete
```
```
In order to pay for my journey
As a customer
I need to know where I've travelled from
```
```
In order to know where I have been
As a customer
I want to see to all my previous trips
```
```
In order to know how far I have travelled
As a customer
I want to know what zone a station is in
```
```
In order to be charged correctly
As a customer
I need a penalty charge deducted if I fail to touch in or out
```
```
In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```
## <a name="Methods">Objects & Methods</a>

### Oystercard

| Methods | Description |
| --- | --- |
| OysterCard.new     | Creates a new instance of Oyster Card                                                                |
| .top_up(amount)    | Allows the user to top up their balance by a given amount                                            |
| .touch_in(station) | Creates a new instance of journey and stores the station as an attribute of journey within the journey log |
| .touch_out(station)| Adds the finish station attribute to the current instance of journey and deduces the fare            |
| .journey_history   | Displays a copy of the journey log|

### JourneyLog

| Methods | Description |
| --- | --- |
| JourneyLog.new | Creates a new instance of Journey Log |
| .in_journey? | Returns true if the last instance of journey in the journey log has a start station and no finish station | 
| .start(station) | Called by the 'touch_in' method on the OysterCard class. It initializes an instance of Journey and passes the station argument to it. It also sets in_journey to true. |
|.finish(station) | Called by the 'touch_out' method on the OysterCard class. It passes the station to the last journey instance in the journey log. Also switches in_journey to false |
| .journeys | Creates a copy of the current Journey Log and outputs it to the user |

### Journey

| Methods | Description |
| --- | --- |
| .start(station) | Sets the station as the @entry_station attribute of the journey instance & sets in_journey to true.
| .finish(station) | Sets the station as the @exit_station attribute of the journey instance & sets in_journey to false.
| .fare | Calulates the fare based on the minimum fare, zones traveled, and if a penalty has been issued for a previous journey |

## <a name="Testing">Testing</a>

Tests were written with RSpec. To run the tests in terminal: 

```bash
$> cd oystercard
$> rspec
```

## <a name="Further_Improvements">Further Improvements</a>

* Write more feature tests
* Refactor RSpec test
* Update README