#' Adds college state information
#'
#' @param recruits_df Recruiting dataframe (*DF*, required)
#'
#' @keywords internal
#' @export
#' @examples
#'
#' college_states(recruits_df)
#'


college_states <- function(recruits_df){
  AL_teams = c("Alabama","Auburn","South Alabama","Troy","UAB",
               "Alabama A&M", "Alabama State","Jacksonville","North Alabama",
               "Samford","Jacksonville State")
  AR_teams = c("Arkansas","Arkansas State","Arkansas-Pine Bluff",
               "Central Arkansas")
  AZ_teams = c("Arizona","Arizona State","Northern Arizona")
  CA_teams = c("California","Fresno State","San Diego State","San Jose State",
               "USC","Stanford","UCLA","Cal Poly","Sacramento State",
               "San Diego","UC Davis")
  CO_teams = c("Air Force","Colorado","Colorado State",
               "Northern Colorado")
  CT_teams = c("UConn","Central Connecticut",
               "Sacred Heart","Yale")
  DC_VA_teams = c("Georgetown","Howard","Liberty","Old Dominion",
                  "Virginia","Virginia Tech","Hampton","James Madison",
                  "Norfolk State","Richmond","VMI","William & Mary")
  DE_teams = c("Delaware","Delaware State")
  FL_teams = c("FIU","Florida","Florida Atlantic","Florida State",
               "Miami","UCF","USF","Bethune-Cookman","Florida A&M",
               "Stetson")
  GA_teams = c("Georgia","Georgia Southern","Georgia State",
               "Georgia Tech","Kennesaw State",
               "Mercer","Savannah State")
  HI_teams = c("Hawai'i")
  IA_teams = c("Iowa","Iowa State","Drake","Northern Iowa")
  ID_teams = c("Boise State","Idaho State","Idaho")
  IL_teams = c("Illinois","Northern Illinois","Northwestern",
               "Eastern Illinois","Illinois State","Southern Illinois",
               "Western Illinois")
  IN_teams = c("Ball State","Indiana","Notre Dame","Purdue",
               "Butler","Indiana State","Valparaiso")
  KS_teams = c("Kansas","Kansas State")
  KY_teams = c("Kentucky","Louisville","Western Kentucky","Eastern Kentucky",
               "Morehead State","Murray State")
  LA_teams = c("Louisiana","Louisiana Tech","Louisiana-Monroe",
               "LSU","Tulane","Grambling","McNeese","Nicholls",
               "Northwestern State","Southeastern Louisiana",
               "Southern")
  MA_teams = c("Boston College","UMass","Harvard",
               "Holy Cross","Merrimack")
  MD_teams = c("Maryland","Navy","Morgan State","Towson")
  ME_teams = c("Maine")
  MI_teams = c("Central Michigan","Eastern Michigan","Michigan",
               "Michigan State","Western Michigan")
  MN_teams = c("Minnesota")
  MO_teams = c("Missouri","Missouri State",
               "Southeast Missouri State")
  MS_teams = c("Ole Miss","Mississippi State","Southern Mississippi",
               "Alcorn State","Jackson State",
               "Mississippi Valley State")
  MT_teams = c("Montana","Montana State")
  NC_teams = c("Appalachian State","Charlotte","Duke","East Carolina",
               "NC State","North Carolina","Wake Forest","Campbell",
               "Davidson","Elon","Gardner-Webb","North Carolina A&T",
               "North Carolina Central","Western Carolina")
  ND_teams = c("North Dakota","North Dakota State")
  NE_teams = c("Nebraska")
  NH_teams = c("Dartmouth","New Hampshire")
  NJ_teams = c("Rutgers","Monmouth","Princeton")
  NM_teams = c("New Mexico","New Mexico State")
  NV_teams = c("Nevada","UNLV")
  NY_teams = c("Army","Buffalo","Syracuse","Albany","Colgate",
               "Columbia","Cornell","Fordham","LIU",
               "Marist","Stony Brook","Wagner")
  OH_teams = c("Akron","Bowling Green","Cincinnati","Kent State",
               "Miami (OH)","Ohio","Ohio State","Toledo",
               "Dayton","Youngstown State")
  OK_teams = c("Oklahoma","Oklahoma State","Tulsa")

  OR_teams = c("Oregon","Oregon State","Portland State")

  PA_teams =  c("Penn State","Pittsburgh","Temple","Bucknell",
                "Duquesne","Lafayette","Lehigh","Pennsylvania",
                "Robert Morris","St Francis (PA)","Villanova")
  RI_teams = c("Brown","Bryant","Rhode Island")
  SC_teams = c("Clemson","Coastal Carolina","South Carolina",
               "Charleston Southern","Furman","Presbyterian",
               "South Carolina State","The Citadel","Wofford",
               "Presbyterian College")
  SD_teams = c("South Dakota","South Dakota State")
  TN_teams = c("Memphis","Middle Tennessee","Tennessee","Vanderbilt",
               "Austin Peay","Chattanooga","East Tennessee State",
               "Tennessee State","Tennessee Tech","UT Martin")
  TX_teams = c("Baylor","Houston","North Texas","Rice","SMU",
               "TCU","Texas","Texas A&M","Texas State","Texas Tech",
               "UTEP","UT San Antonio","UTSA","Abilene Christian",
               "Houston Baptist","Incarnate Word","Lamar",
               "Prairie View","Sam Houston State","Stephen F. Austin",
               "Tarleton State","Texas Southern")
  UT_teams = c("BYU","Utah","Utah State","Dixie State",
               "Southern Utah","Weber State")
  WA_teams = c("Washington","Washington State",
               "Eastern Washington")
  WI_teams = c("Wisconsin")
  WV_teams = c("Marshall","West Virginia")
  WY_teams = c("Wyoming")

  recruits_df <- recruits_df %>%
    mutate(
      college_state = case_when(
        Committed.to %in% AL_teams ~ 'AL',
        Committed.to %in% AR_teams ~ 'AR',
        Committed.to %in% AZ_teams ~ 'AZ',
        Committed.to %in% CA_teams ~ 'CA',
        Committed.to %in% CO_teams ~ 'CO',
        Committed.to %in% CT_teams ~ 'CT',
        Committed.to %in% DC_VA_teams ~ 'DC_VA',
        Committed.to %in% DE_teams ~ 'DE',
        Committed.to %in% FL_teams ~'FL',
        Committed.to %in% GA_teams ~ 'GA',
        Committed.to %in% HI_teams ~ 'HI',
        Committed.to %in% IA_teams ~ 'IA',
        Committed.to %in% ID_teams ~ 'ID',
        Committed.to %in% IL_teams ~ 'IL',
        Committed.to %in% IN_teams ~'IN',
        Committed.to %in% KS_teams ~ 'KS',
        Committed.to %in% KY_teams ~ 'KY',
        Committed.to %in% LA_teams ~ 'LA',
        Committed.to %in% MA_teams ~ 'MA',
        Committed.to %in% MD_teams ~ 'MD',
        Committed.to %in% ME_teams ~ 'ME',
        Committed.to %in% MI_teams ~ 'MI',
        Committed.to %in% MN_teams ~ 'MN',
        Committed.to %in% MO_teams ~ 'MO',
        Committed.to %in% MS_teams ~ 'MS',
        Committed.to %in% MT_teams ~ 'MT',
        Committed.to %in% NC_teams ~ 'NC',
        Committed.to %in% ND_teams ~ 'ND',
        Committed.to %in% NE_teams ~ 'NE',
        Committed.to %in% NH_teams ~ 'NH',
        Committed.to %in% NJ_teams ~ 'NJ',
        Committed.to %in% NM_teams ~ 'NM',
        Committed.to %in% NV_teams ~ 'NV',
        Committed.to %in% NY_teams ~ 'NY',
        Committed.to %in% OH_teams ~ 'OH',
        Committed.to %in% OK_teams ~ 'OK',
        Committed.to %in% OR_teams ~ 'OR',
        Committed.to %in% PA_teams ~ 'PA',
        Committed.to %in% RI_teams ~ 'RI',
        Committed.to %in% SC_teams ~ 'SC',
        Committed.to %in% SD_teams ~ 'SD',
        Committed.to %in% TN_teams ~ 'TN',
        Committed.to %in% TX_teams ~ 'TX',
        Committed.to %in% UT_teams ~ 'UT',
        Committed.to %in% WA_teams ~ 'WA',
        Committed.to %in% WI_teams ~ 'WI',
        Committed.to %in% WV_teams ~ 'WV',
        Committed.to %in% WY_teams ~ 'WY',
        TRUE ~ 'OUT-OF-COUNTRY'
      ))
  return(recruits_df)
}
