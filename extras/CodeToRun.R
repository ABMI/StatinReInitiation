library(StatinReInitiation0829v3)

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
options(andromedaTempFolder = "s:/andromedaTemp")



# Maximum number of cores to be used:
# maxCores <- parallel::detectCores()
maxCores <- 30



# The folder where the study intermediate and result files will be written:
outputFolder <- "/home/harrin1998/HRK_R/Output/tutorial/StatinReInitiation0829v3"



# java
Sys.setenv('DATABASECONNECTOR_JAR_FOLDER'='/home/harrin1998/jdbc')



# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "sql server",
                                                                server = '10.5.99.50',
                                                                user = 'harrin1998',
                                                                password = 'qlqjs1998@',
                                                                port = '1433',
                                                                pathToDriver = Sys.getenv("DATABASECONNECTOR_JAR_FOLDER"))




# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "CDMPv535_ABMI.dbo"



# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "cohortDb.dbo"
cohortTable <- "HRK_PLE_StatinReInitiation0829v3"



# Some meta-information that will be used by the export function:
databaseId <- "CDMPv535_ABMI.dbo"
databaseName <- "CDMPv535_ABMI.dbo"
databaseDescription <- "CDMPv535_ABMI.dbo"




# For Oracle: define a schema that can be used to emulate temp tables:
oracleTempSchema <- NULL



execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        oracleTempSchema = oracleTempSchema,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        createCohorts = T,
        synthesizePositiveControls = F,
        runAnalyses = F,
        packageResults = F,
        maxCores = maxCores)



resultsZipFile <- file.path(outputFolder, "export", paste0("Results_", databaseId, ".zip"))
dataFolder <- file.path(outputFolder, "shinyData")



# You can inspect the results if you want:
prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder)
launchEvidenceExplorer(dataFolder = dataFolder, blind = FALSE, launch.browser = FALSE)



# Upload the results to the OHDSI SFTP server:
privateKeyFileName <- ""
userName <- ""
uploadResults(outputFolder, privateKeyFileName, userName)