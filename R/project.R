pride_archive_url <- "http://www.ebi.ac.uk/pride/ws/archive"
pride_archive_url_dev <- "http://wwwdev.ebi.ac.uk/pride/ws/archive"

MISSING_VALUE <- "Not available"

#' ProjectSummaryList represents a PRIDE Archive project collection
#'
#' @importFrom rjson fromJSON
#' @export 
#' @exportClass ProjectSummaryList
setClass(
    "ProjectSummaryList", 
    representation(
        query = "character",
        project.list = "list",
        page.number = "numeric",
        page.size = "numeric"
    ),
    prototype(
        query = "",
        project.list = list(), 
        page.number = 0,
        page.size = 10
    )
)

setMethod("show",
          signature = "ProjectSummaryList",
          definition = function(object) {
              cat("A ", class(object), sep="")
              cat(" representing the search results for query ", object@query, " with \n", sep="")
              cat("    Projects in page: ", length(object@project.list), "\n", sep="")
              cat("    Page number: ", object@page.number, " \n", sep="")
              cat("    Page size: ", object@page.size, " projects per page\n", sep="")
              invisible(NULL)
          }
)

#' Returns the query term used to retrieve the ProjectSummaryList
#' 
#' @param object a ProjectSummaryList instance
#' @return the query term used to retrieve this ProjectSummaryList
#' @author Jose A. Dianes
#' @export
setMethod("query", "ProjectSummaryList", function(object) object@query)

#' Returns a project summary page as a list
#' 
#' @param object a ProjectSummaryList instance
#' @return the protein list
#' @author Jose A. Dianes
#' @export
setMethod("project.list", "ProjectSummaryList", function(object) object@project.list)

#' Returns the page number for a given protein details list
#' 
#' @param object a ProjectSummaryList instance
#' @return the page number 
#' @author Jose A. Dianes
#' @export
setMethod("page.number", "ProjectSummaryList", function(object) object@page.number)

#' Returns the page size for a given protein details list
#' 
#' @param object a ProjectSummaryList instance
#' @return the page size 
#' @author Jose A. Dianes
#' @export
setMethod("page.size", "ProjectSummaryList", function(object) object@page.size)

#' Returns a data frame from a ProteinDetailList instance
#'
#' @param x The ProjectSummaryList instance
#' @param row.names optional row names
#' @param optional optional
#' @return The page of project summaries as a data frame
#' @author Jose A. Dianes
#' @details TODO
#' @export
setMethod("as.data.frame", "ProjectSummaryList",
          function(object, row.names=NULL, optional=FALSE, ...)
          {
              value <- list.to.data.frame(object@project.list)
              
              return(value)
          }
)

#' ProjectSummary represents a PRIDE Archive project dataset
#'
#' @importFrom rjson fromJSON
#' @export 
#' @exportClass ProjectSummary
setClass(
    "ProjectSummary", 
    
    slots = c(
              accession = "character", 
              project.title = "character",
              project.description = "character",
              publication.date = "POSIXct",
              num.assays = "numeric",
              species = "character",
              tissues = "character",
              ptm.names = "character",
              instrument.names = "character",
              project.tags = "character",
              submission.type = "character"
            ),
    
    prototype = list(
                  project.title = MISSING_VALUE,
                  project.description = MISSING_VALUE,
                  publication.date = Sys.time(),
                  num.assays = 0,
                  species = MISSING_VALUE,
                  tissues = MISSING_VALUE,
                  ptm.names = MISSING_VALUE,
                  instrument.names = MISSING_VALUE,
                  project.tags = MISSING_VALUE,
                  submission.type = MISSING_VALUE
                ),
    validity = function(object) {
      # check accession
      if (!is.character(object@accession) || nchar(object@accession) == 0 || is.na(object@accession))
        return("'accession' must be a single valid string")  
      
      # check project.title
      if (!is.character(object@project.title) || nchar(object@project.title) == 0 || is.na(object@project.title))
        return("'project.title' must be a single valid string")  
      
      # check project.description
      if (!is.character(object@project.description) || nchar(object@project.description) == 0 || is.na(object@project.description))
        return("'project description' must be a single valid string")  
      
      # check publication.date
      if (!is(object@publication.date, "POSIXct") || is.na(object@publication.date))
        return("'publication.date' must be a single valid date")  
      
      # check num.assays
      if (!is.numeric(object@num.assays) || object@num.assays < 0 || is.na(object@num.assays))
        return("'num.assays' must be a none negative integer")  
      
      # check species
      if (!is.character(object@species) || 0 %in% nchar(object@species) || is.na(object@species))
        return("'species' must be a one or multiple valid strings")  
      
      # check tissues
      if (!is.character(object@tissues) || 0 %in% nchar(object@tissues) || is.na(object@tissues))
        return("'tissues' must be a one or multiple valid strings")  
      
      # check ptm.names
      if (!is.character(object@ptm.names) || 0 %in% nchar(object@ptm.names) || is.na(object@ptm.names))
        return("'ptm.names' must be a one or multiple valid strings")
      
      # check instrument.names
      if (!is.character(object@instrument.names) || 0 %in% nchar(object@instrument.names) || is.na(object@instrument.names))
        return("'instrument.names' must be a one or multiple valid strings")
      
      # check project.tags
      if (!is.character(object@project.tags) || 0 %in% nchar(object@project.tags) || is.na(object@project.tags))
        return("'project.tags' must be a one or multiple valid strings")
      
      # check submission.type
      if (!is.character(object@submission.type) || nchar(object@submission.type) == 0 || is.na(object@submission.type))
        return("'submission.type' must be a single valid string")
    }
)

#' Constructor for ProjectSummary
#' 
#' @param accession project accession
#' @param project.title the title of the project
#' @param project.description the description of the project
#' @param publication.date the date when the project was made public by PRIDE
#' @param num.assays the number of assays
#' @param species the species of the project
#' @param tissues the tissues of the projecte
#' @param ptm.names the names of the PTM for the project
#' @param instrument.names the names of the instruments used in the project
#' @param project.tags the tags for the project
#' @param submission.type the type of the submission, e.g. COMPLETE, PARTIAL or PRIDE
#' @export 
ProjectSummary <- function(accession, 
                           project.title, 
                           project.description, 
                           publication.date, 
                           num.assays, 
                           species,
                           tissues,
                           ptm.names,
                           instrument.names,
                           project.tags,
                           submission.type) {
  new("ProjectSummary", 
      accession = accession,
      project.title = project.title,
      project.description = project.description,
      publication.date = publication.date,
      num.assays = num.assays,
      species = species,
      tissues = tissues,
      ptm.names = ptm.names,
      instrument.names = instrument.names,
      project.tags = project.tags,
      submission.type = submission.type
      )
}

#' Show the print-out version of the content in a ProjectSummary
#' 
#' @param object a given ProjectSummary
#' @export 
setMethod("show",
          signature = "ProjectSummary",
          definition = function(object) {
              cat("An object of class ", class(object), "\n", sep="")
              cat(" with ", object@num.assays, " assays and made public in ", as.character(object@publication.date), "\n", sep="")
              cat("    Accession: ", object@accession, "\n", sep="")
              cat("    Title: ", object@project.title, "\n", sep="")
              cat("    Description: ", object@project.description, "\n", sep="")
              cat("    Species: ", object@species, "\n", sep=" ")
              cat("    Tissues: ", object@tissues, "\n", sep=" ")
              cat("    PTMs: ", object@ptm.names, "\n", sep=" ")
              cat("    Instruments: ", object@instrument.names, "\n", sep=" ")
              cat("    Tags: ", object@project.tags, "\n", sep=" ")
              cat("    Submission type: ", object@submission.type, "\n", sep="")
              invisible(NULL)
          }
)

#' Returns a project accession
#' 
#' @param object a ProjectSummary
#' @return the accession
#' @author Jose A. Dianes
#' @export
setMethod("accession", "ProjectSummary", function(object) object@accession)

#' Replaces a project accession
#' 
#' @param object a ProjectSummary
#' @param value the accession
#' @author Jose A. Dianes
#' @export
setReplaceMethod("accession", "ProjectSummary",
          function(object, value) {
              object@accession <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project title
#' 
#' @param object a ProjectSummary
#' @return the project title
#' @author Jose A. Dianes
#' @export
setMethod("project.title", "ProjectSummary", function(object) object@project.title)

#' Replaces a project title
#' 
#' @param object a ProjectSummary
#' @param value the title
#' @author Jose A. Dianes
#' @export
setReplaceMethod("project.title", "ProjectSummary",
          function(object, value) {
              object@project.title <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project description
#' 
#' @param object a ProjectSummary
#' @return the project description
#' @author Jose A. Dianes
#' @export
setMethod("project.description", "ProjectSummary", function(object) object@project.description)

#' Replaces a project description
#' 
#' @param object a ProjectSummary
#' @param value the project description
#' @author Jose A. Dianes
#' @export
setReplaceMethod("project.description", "ProjectSummary",
          function(object, value) {
              object@project.description <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project publication date
#' 
#' @param object a ProjectSummary
#' @return the project publication date
#' @author Jose A. Dianes
#' @export
setMethod("publication.date", "ProjectSummary", function(object) object@publication.date)

#' Replaces a project publication date
#' 
#' @param object a ProjectSummary
#' @param value the publication date
#' @author Jose A. Dianes
#' @export
setReplaceMethod("publication.date", "ProjectSummary",
          function(object, value) {
              object@publication.date <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project number of assays
#' 
#' @param object a ProjectSummary
#' @return the number of assays
#' @author Jose A. Dianes
#' @export
setMethod("num.assays", "ProjectSummary", function(object) object@num.assays)

#' Replaces a project number of assays
#' 
#' @param object a ProjectSummary
#' @param value the number of assays
#' @author Jose A. Dianes
#' @export
setReplaceMethod("num.assays", "ProjectSummary",
          function(object, value) {
              object@num.assays <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project species
#' 
#' @param object a ProjectSummary
#' @return the project species
#' @author Jose A. Dianes
#' @export
setMethod("species", "ProjectSummary", function(object) object@species)

#' Replaces the project species
#' 
#' @param object a ProjectSummary
#' @param value the species
#' @author Jose A. Dianes
#' @export
setReplaceMethod("species", "ProjectSummary",
          function(object, value) {
              object@species <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project tissues
#' 
#' @param object a ProjectSummary
#' @return the project tissues
#' @author Jose A. Dianes
#' @export
setMethod("tissues", "ProjectSummary", function(object) object@tissues)

#' Replaces the project tissues
#' 
#' @param object a ProjectSummary
#' @param value the tissues
#' @author Jose A. Dianes
#' @export
setReplaceMethod("tissues", "ProjectSummary",
          function(object, value) {
              object@tissues <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project modification names
#' 
#' @param object a ProjectSummary
#' @return the project modification names
#' @author Jose A. Dianes
#' @export
setMethod("ptm.names", "ProjectSummary", function(object) object@ptm.names)

#' Replaces the project PTMs
#' 
#' @param object a ProjectSummary
#' @param value the PTMs
#' @author Jose A. Dianes
#' @export
setReplaceMethod("ptm.names", "ProjectSummary",
          function(object, value) {
              object@ptm.names <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project instrument names
#' 
#' @param object a ProjectSummary
#' @return the project instrument names
#' @author Jose A. Dianes
#' @export
setMethod("instrument.names", "ProjectSummary", function(object) object@instrument.names)

#' Replaces the project instrument nanmes
#' 
#' @param object a ProjectSummary
#' @param value the instrument names
#' @author Jose A. Dianes
#' @export
setReplaceMethod("instrument.names", "ProjectSummary",
          function(object, value) {
              object@instrument.names <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project tags
#' 
#' @param object a ProjectSummary
#' @return the project tags
#' @author Jose A. Dianes
#' @export
setMethod("project.tags", "ProjectSummary", function(object) object@project.tags)

#' Replaces the project tags
#' 
#' @param object a ProjectSummary
#' @param value the project tags
#' @author Jose A. Dianes
#' @export
setReplaceMethod("project.tags", "ProjectSummary",
          function(object, value) {
              object@project.tags <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a project submission type
#' 
#' @param object a ProjectSummary
#' @return the project submission type
#' @author Jose A. Dianes
#' @export
setMethod("submission.type", "ProjectSummary", function(object) object@submission.type)

#' Replaces the project submission type
#' 
#' @param object a ProjectSummary
#' @param value the submission type
#' @author Jose A. Dianes
#' @export
setReplaceMethod("submission.type", "ProjectSummary",
          function(object, value) {
              object@submission.type <- value
              if (validObject(object))
                  return(object)
          }
)

#' Returns a data frame from ProjectSummary inputs
#'
#' @param x The project summaries
#' @param row.names optional row names
#' @return The project summaries as a data frame
#' @author Jose A. Dianes
#' @details TODO
#' @export
setMethod("as.data.frame", "ProjectSummary",
    function(object, row.names=NULL, optional=FALSE, ...)
    {
        # set row names if provided
        if (is.null(row.names))
            row.names <- object@accession
        # create the data frame just with the accession column
        value <- list(object@accession)
        attr(value, "row.names") <- row.names
        class(value) <- "data.frame"
        names(value) <- c("accession")
        # add the rest of the columns
        value$project.title <- object@project.title
        value$project.description <- object@project.description
        value$publication.date <- object@publication.date
        value$num.assays <- object@num.assays
        value$species <- paste(object@species, collapse=" || ")
        value$tissues <- paste(object@tissues, collapse=" || ")
        value$ptm.names <- paste(object@ptm.names, collapse=" || ")
        value$instrument.names <- paste(object@instrument.names, collapse=" || ")
        value$project.tags <- paste(object@project.tags, collapse=" || ")
        value$submissionType <- object@submission.type
        
        return(value)
    }
)

format.ProjectSummary <- function(x, ...) paste0(x@accession, ", ", x@title)

#' Returns a ProjectSummary instance from a JSON string representation
#'
#' @param json_str The JSON object
#' @param file the name of a file to read the json_str from; this can also be a URL. Only one of json_str or file must be supplied.
#' @param method use the C implementation, or the older slower (and one day to be depricated) R implementation
#' @param unexpected.escape changed handling of unexpected escaped characters. Handling value should be one of "error", "skip", or "keep"; on unexpected characters issue an error, skip the character, or keep the character
#' @return The ProjectSummary instance
#' @author Jose A. Dianes
#' @details TODO
#' @importFrom rjson fromJSON
#' @export
from.json.ProjectSummary <- function(json.object) {
    res <- new("ProjectSummary",
               accession = json.object$accession,
               project.title = json.object$title,
               project.description = ifelse(is.null(json.object$projectDescription), MISSING_VALUE, json.object$projectDescription),
               publication.date = as.POSIXct(json.object$publicationDate),
               num.assays = json.object$numAssays,
               species = ifelse(is.null(json.object$species) || (length(json.object$species)==0), MISSING_VALUE, json.object$species),
               tissues = ifelse(is.null(json.object$tissues) || (length(json.object$tissues)==0), MISSING_VALUE, json.object$tissues),
               ptm.names = ifelse(is.null(json.object$ptmNames) || (length(json.object$ptmNames)==0), MISSING_VALUE, json.object$ptmNames),
               instrument.names = ifelse(is.null(json.object$instrumentNames) || (length(json.object$instrumentNames)==0), MISSING_VALUE, json.object$instrumentNames),
               project.tags = ifelse(is.null(json.object$projectTags) || (length(json.object$projectTags)==0), MISSING_VALUE, json.object$projectTags),
               submission.type = json.object$submissionType
    )
    
    return (res)
}

#' Returns a PRIDE Archive project
#'
#' @param accession The project accession
#' @return The project in as object
#' @author Jose A. Dianes
#' @details TODO
#' @importFrom rjson fromJSON
#' @export
get.ProjectSummary <- function(accession) {
    from.json.ProjectSummary(fromJSON(file=paste0(pride_archive_url, "/project/", accession), method="C"))
}

#' Returns a list of PRIDE Archive project summaries
#'
#' @param count the maximum number of projects
#' @return The list of ProjectSummary objects
#' @author Jose A. Dianes
#' @details TODO
#' @importFrom rjson fromJSON
#' @export
get.list.ProjectSummary <- function(count=10) {
    json.list <- fromJSON(file=paste0(pride_archive_url, "/project/list", "?show=", count), method="C")
    project.list <- lapply(json.list[[1]], function(x) { from.json.ProjectSummary(x)})
    return(project.list)
}

#' Returns a series of PRIDE Archive projects
#' to satisify a given query. This is actually a 
#' query filtered version of project_list
#'
#' @param q The query terms
#' @param count The maximum number of search results
#' @return The search results in a list of objects
#' @author Jose A. Dianes
#' @details TODO
#' @importFrom rjson fromJSON
#' @export
search.list.ProjectSummary <- function(q, page.number=0, page.size=100) {
    json.list <- fromJSON(file=paste0(pride_archive_url, "/project/list", "?show=", page.size, "&page=", page.number, "&q=", q), method="C")
    project.list <- lapply(json.list[[1]], function(x) { from.json.ProjectSummary(x)})
    projectSummaryList <- new("ProjectSummaryList", 
                               query=q, 
                               project.list=project.list, 
                               page.number=page.number, 
                               page.size=page.size)
    return(projectSummaryList)
}

#' Returns the number of public projects in PRIDE Archive
#'
#' @return The count of projects
#' @author Jose A. Dianes
#' @details TODO
#' @importFrom rjson fromJSON
#' @export
count.ProjectSummary <- function() {
    projectCount <- fromJSON(file=paste0(pride_archive_url, "/project/count"), method="C")
    projectCount                          
}

