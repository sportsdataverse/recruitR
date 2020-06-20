#' Determines whether the recruit was an in-state recruit,
#' from a bordering state, or from out of the region for the college
#'
#' @param recruits_df Recruiting dataframe (*DF*, required)
#'
#' @keywords internal
#' @export
#' @examples
#'
#' bordering_states(recruits_df)
#'


bordering_states<-function(recruits_df){
  recruits_df <- recruits_df %>%
    mutate(
      college_territory = case_when(
        stateProvince == college_state ~ "In-State",
        stateProvince == 'AL' & college_state %in% c('FL','GA','MS','TN') ~ 'Bordering',
        stateProvince == 'AR' & college_state %in% c('LA','MS','MO','OK','TN','TX') ~ 'Bordering',
        stateProvince == 'AZ' & college_state %in% c('CA','CO','NV','NM','UT') ~ 'Bordering',
        stateProvince == 'CA' & college_state %in% c('AZ','NV','OR') ~ 'Bordering',
        stateProvince == 'CO' & college_state %in% c('AZ','KS','NE','NM','OK','UT','WY') ~ 'Bordering',
        stateProvince == 'CT' & college_state %in% c('MA','NY','RI') ~ 'Bordering',
        stateProvince == 'DC' & college_state %in% c('KY','MD','NC','TN','WV') ~ 'Bordering',
        stateProvince == 'DE' & college_state %in% c('MD','NY','PA') ~ 'Bordering',
        stateProvince == 'FL' & college_state %in% c('AL','GA') ~ 'Bordering',
        stateProvince == 'GA' & college_state %in% c('AL','FL','NC','SC','TN') ~ 'Bordering',
        stateProvince == 'IA' & college_state %in% c('IL','MN','MO','NE','SD','WI') ~ 'Bordering',
        stateProvince == 'ID' & college_state %in% c('MT','NV','OR','UT','WA','WY') ~ 'Bordering',
        stateProvince == 'IL' & college_state %in% c('IN','IA','MI','KY','MO','WI') ~ 'Bordering',
        stateProvince == 'IN' & college_state %in% c('IL','KY','MI','OH') ~ 'Bordering',
        stateProvince == 'KS' & college_state %in% c('CO','MO','NE','OK') ~ 'Bordering',
        stateProvince == 'KY' & college_state %in% c('IL','IN','MO','OH','TN','VA','WV') ~ 'Bordering',
        stateProvince == 'LA' & college_state %in% c('AR','MS','TX') ~ 'Bordering',
        stateProvince == 'MA' & college_state %in% c('CT','NY','NH','RI','VT') ~ 'Bordering',
        stateProvince == 'MD' & college_state %in% c('DE','PA','VA','WV') ~ 'Bordering',
        stateProvince == 'ME' & college_state %in% c('NH') ~ 'Bordering',
        stateProvince == 'MI' & college_state %in% c('IL','IN','MN','OH','WI') ~ 'Bordering',
        stateProvince == 'MN' & college_state %in% c('IA','MI','ND','SD','WI') ~ 'Bordering',
        stateProvince == 'MO' & college_state %in% c('AR','IL','IA','KS','KY','NE','OK','TN') ~ 'Bordering',
        stateProvince == 'MS' & college_state %in% c('AL','AR','LA','TN') ~ 'Bordering',
        stateProvince == 'MT' & college_state %in% c('ID','ND','SD','WY') ~ 'Bordering',
        stateProvince == 'NC' & college_state %in% c('GA','SC','TN','VA') ~ 'Bordering',
        stateProvince == 'ND' & college_state %in% c('MN','MT','SD') ~ 'Bordering',
        stateProvince == 'NE' & college_state %in% c('CO','IA','KS','MO','SD','WY') ~ 'Bordering',
        stateProvince == 'NH' & college_state %in% c('ME','MA','VT') ~ 'Bordering',
        stateProvince == 'NJ' & college_state %in% c('DE','NY','PA') ~ 'Bordering',
        stateProvince == 'NM' & college_state %in% c('AZ','CO','OK','TX','UT') ~ 'Bordering',
        stateProvince == 'NV' & college_state %in% c('AZ','CA','ID','OR','UT') ~ 'Bordering',
        stateProvince == 'NY' & college_state %in% c('CT','MA','NJ','PA','RI','VT') ~ 'Bordering',
        stateProvince == 'OH' & college_state %in% c('IN','KY','MI','PA','WV') ~ 'Bordering',
        stateProvince == 'OK' & college_state %in% c('AR','CO','KS','MO','NM','TX') ~ 'Bordering',
        stateProvince == 'OR' & college_state %in% c('CA','ID','NV','WA') ~ 'Bordering',
        stateProvince == 'PA' & college_state %in% c('DE','MD','NJ','NY','OH','WV') ~ 'Bordering',
        stateProvince == 'RI' & college_state %in% c('CT','MA','NY') ~ 'Bordering',
        stateProvince == 'SC' & college_state %in% c('GA','NC') ~ 'Bordering',
        stateProvince == 'SD' & college_state %in% c('IA','MN','MT','NE','ND','WY') ~ 'Bordering',
        stateProvince == 'TN' & college_state %in% c('AL','AR','GA','KY','MS','MO','NC','VA') ~ 'Bordering',
        stateProvince == 'TX' & college_state %in% c('AR','LA','NM','OK') ~ 'Bordering',
        stateProvince == 'UT' & college_state %in% c('AZ','CO','ID','NV','NM','WY') ~ 'Bordering',
        stateProvince == 'VA' & college_state %in% c('KY','MD','NC','TN','WV') ~ 'Bordering',
        stateProvince == 'WA' & college_state %in% c('ID','OR') ~ 'Bordering',
        stateProvince == 'WI' & college_state %in% c('IL','IA','MI','MN') ~ 'Bordering',
        stateProvince == 'WV' & college_state %in% c('KY','MD','OH','PA','VA') ~ 'Bordering',
        stateProvince == 'WY' & college_state %in% c('CO','ID','MT','NE','SD','UT') ~ 'Bordering',
        TRUE ~ 'Out-of-Region'
      )
    )
  return(recruits_df)
}
