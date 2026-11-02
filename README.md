## Ema ranking data

### State
* Imported data from Andrews dump
* Imported new data from Idekerg, including refereeEvents
    date of refereeevents needs to be fixed
    some few id seems to not be good

## file structure
    countries/<member>
        contains a guest file and a unk.
        the unknown should all be transfered to respective country.

    tournament/year/<ruleset-id>
        my initial thought what we should have the actual results in 
        a separate folder. idk

## Country file structure
    Member {
        CountryCode: String,
        Country: String, // descriptive Name
        Organisation: Option<String>, // descriptive Name of main org.
        Website: Option<String>
        Links: Vec<String>
        Players: Vec<Player>
    }

    Player {
        EmaNumber: String // player id
        FirstName: String // The name fields should have Proper case and be "Latin script"
        LastName: String  // We can always make it upper etc on demand
        SortingName: Option<String> // Sorting override, default "<LastName>, <FirstName>"
        NativeName: Option<String> // For non Latin names, if desired
        Club: Option<String>
        Events: Vec<PlayerEvents>
    }

    PlayerEvents {
        Type: Enum // String se below
        Date: Date // format 'yyyy-mm-dd'
        ToDate: Option<Date> // end date of timelimited events
        EmaNumber: Option<String> // ema number related
        Reference: Option<String> // reference document if needed
    }

### PlayerEvents
#### RefereeRCR/RefereeMCR
    Became a referee
    Optionally a ToDate if we want to restrict the qualification over time
    currently the data has bad date and the event in an additional Note field

#### Banned/Suspended
    Player is banned or suspended
    Optional ToDate -- prefered
    Reference is probably desired?

    The thoughtpattern is that
    Suspended: They are ranked and generate quota for the country, but they are 
        not listed with a rank on the country ranking page (or optionally just marked to be excluded)
    Banned: They cannot be listed in the active ranking

#### TransferedTo/TransferedFrom
    EmaNumber: <requireid>
    Player has transfered from an old emaid to a new,
    both emaid should still exist in the system on their representive countries.
    a player with a TransferedTo is thereby not part of the current member

## Tournament file structure
    Tournament {
        Name: String
        Country: String     // country code
        Ruleset: String // MCR or RCR -- we want others for nonema events?
        Url: Option<String>
        Place: Option<String>
        Date: Date,
        ToDate: Option<Date> // For multiday tournaments
        DateDescription: Option<String> // unsure if this is a field we want to keep
        Referee: Vec<PlayerEntity>
        Observer: Vec<PlayerEntity>
        NrDays: Option<Number>
        NrPlayers: Option<Number>
        NrCountries: Option<Number>
        MersWeight: Option<Number>
        Results: Vec<ResultEntry>
        }

    ResultEntry {
        Placement: Number
        EmaNumber: Option<String>       // Either emanumber or Player field
        Player: Option<PlayerEntity>
        Substitute: Option<bool> // basically, true or not existing
        Result: RCRResult/MCRResult enum
        }

    RCRResult: just number

    MCRResult {
        TablePoints: number
        ContestPoints: Number
        }

    PlayerEntity {
        Ema: Option<String>         // either ema number or the rest of the fields
        FirstName: Option<String>
        LastName: Option<String>
        RepresentingNationality: Option<String>
        }
