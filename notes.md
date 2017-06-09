# For further research
* There's an interesting mini-network with Qusta b. Luqa (OA 50129) and some lesser-known figures.
* At this point (starting with just OA people who have religious affiliation marked and connecting them using page numbers), there is a network including some Bukthishos (OA 4134, etc.) that seems to have strong inward ties and be isolated from non-Christians. Could see if I could make anything more of this using al-Jahiz/Fihrist.
* Note the Christian-Jewish pair Salmawayh (OA 4125) and Masarajwayh (OA 50096). This could also perhaps be expanded using al-Jahiz.
* Fadl Allah (OA 15066) the Christian is connected to Zindiq, convert to Islam, and Muslims.
* Jewish-Muslim network centered on Ishaq (OA 50091).
* Isolated Jewish cluster at Ismail (OA 50092).
* Using Group attributes layout on religious affiliation, can easily see individuals who had interreligious connections.
___
## Things to measure
* Density of (1) references to persons in texts.
* Density of (2) interactions in texts, particularly (3) interreligious and (4) personal.
___
## Techniques to try
1. person density
 * Measure density of names by comparing density of common name elements (bin/bint) to density of common, unambiguous names (Muhammad, Ahmad, etc.). If possible also compare with names tagged from OA name list.
 * Tag names from OA list. Tag each element separately (Abu Ali, Ahmad, b. Ibrahim). Then combine adjacent or tag certainty of persName based on adjacency.
 * Turn name list into HTML and use Alpheos to check for names that are common words. Use this to label persName certainty.
 * Check accuracy of above methods on samples. Also provide ratio of name element occurrence (bin/bint) to actual name density using samples. E.g., occurrence of 10 bin/bint implies 7 persons, i.e. multiply bin/bint occurrence by 0.7.
 * Estimate rate of person reoccurrence in given text by ...
     * Extrapolating from reoccurrence across samples and
     * Testing for shuhbas
2. interactions density
 * Using samples, test whether person density is an indicator of interactions density.
 * Using samples, test whether person adjacency, such as occurrence within same <p> or page is acceptable measure of interactions.
3. interreligious density
 * Use labels from OA plus additional keywords (church, bishop, synagogue, etc.) to measure density, esp. of affiliations different from author's own.
 * Check above against samples (and perhaps tweak keywords accordingly.)
 * Tag persNames using shuhbas from OA and test accuracy of results. Leverage with person's religious affiliation to track interreligious feature (this could work in texts that don't necessarily label religion, like al-Jahiz's corpus). If this works it could also be used to construct a preliminary network for tagged adjacent persons.
 * Use page reference of person in OA to estimate where in text someone will be mentioned and tag persName with URI (even if no shuhba) (this could work in texts that don't necessarily label religion, like al-Jahiz's corpus). If this works it could also be used to construct a preliminary network for tagged adjacent persons.
4. density of personal interactions
 * Use samples to construct keywords (verbs?) for personal interactions.
 * Limit above interactions density using these keywords.
 * Test accuracy against samples.
 * Also test/tweak accuracy using life places and dates -- whether it is possible these people interacted.
 ___
 ## Constructing preliminary networks
  * Based on page/paragraph cooccurrence
  * Based on adjacency (if above URI tagging methods work).
  * Based on date-place cooccurrence. (OA texts could also be plotted according to date and place using record info and arranging citations in order. Compare this to Romanov's results for plotting dates.)
