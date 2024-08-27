import Foundation

/*{
"USER": "DR0ABC",
"PSWD": "******",
"DUMP": 0,
"SPOT": [
{
"MYCALL" : "DR0ABC",
"ACTIVATOR" : "DM7N/P",
"REF" : "DLFF-0125",
"KHZ" : "145425",
"MODE" : "FM",
"REMARKS" : "[EG] Big Signal!"
}
]
}*/

struct CQGMASelfSpot {
    let MYCALL: String
    let ACTIVATOR: String
    let REF: String
    let KHZ: String
    let MODE: String
    let REMARKS: String
}
