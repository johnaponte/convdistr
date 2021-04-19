### Comments to verseion 1.5.3
Date has been updated

### Comments to version 1.5.2
Description updated to the new dependence on shiny

### Comments to version 1.5.1
Thanks for the comments,
Please do not modify the .GlobalEnv. This is not allowed by the CRAN policies. e.g.: rm(".Random.seed", envir = .GlobalEnv)

>> The function cinqnum.DISTRIBUTION now uses repeatable function from shiny which has been already approve by CRAN.
Now the set.seed and .GlobalEnv functions are only used on the Test functions which are fundamental to test the desired behaviour of the functions.

### END of comments

Thanks for the comments. All issues has been addressed

#### Comments
If there are references describing the methods in your package, please add these in the description field of your DESCRIPTION file in the form
authors (year) <doi:...>
authors (year) <arXiv:...>
authors (year, ISBN:...)
or if those are not available: <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for auto-linking.
(If you want to add a title as well please put it in quotes: "Title")
 >> DESCRIPTION FILE HAS BEEN MODIFIED
 
Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation. Please write about the structure of the output (class) and also what the output means. (If a function does not return a value, please document that too, e.g. \value{No return value, called for side effects} or similar)
Missing Rd-tags:
    cinqnum.Rd: \value
    DISTRIBUTION.Rd:  \value
    new_MULTINORMAL.Rd: \value
    plot.DISTRIBUTION.Rd: \value
    rfunc.default.Rd: \value
    rfunc.DISTRIBUTION.Rd: \value
>> Return value has been included in the documentation

Please do not modify the .GlobalEnv. This is not allowed by the CRAN policies. e.g.: .Random.seed
>> The approach to make the function reproductible has been changed.

### END of comments

## Test environments
* local R installation, R 4.0.4
* ubuntu 16.04 (on travis-ci), R 4.0.4
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
