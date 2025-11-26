// JavaScript source code
const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({ "headless": false, args: ['--start-maximized'] }); // Open the browser
    const dataPage = await browser.newPage();
    await dataPage.goto('https://www.livesport.com/en/player/djokovic-novak/AZg49Et9/');
    let playerName = 'Djokovic N.';  // Manually set the shortened player name as it appears on the website

    await dataPage.setViewport({ width: 1366, height: 768 });

    // Initalize variable for dataMatrix
    var dataMatrix = []; // Declare dataMatrix
    n = 0;  // n will be the number of sets overall (NUmber of rows of matrix)

    // Number of clicks to scroll down the page
    clickNumber = 50;
    for (let i = 1; i < clickNumber; i++) {
        await dataPage.waitForSelector('a[class="event__more event__more--static"]');
        await dataPage.click('a[class="event__more event__more--static"]');
        await dataPage.waitForTimeout(2000);
    }

    //  Get the number of matches available
    await dataPage.waitForSelector('div[title="Click for match detail!"]');
    let allMatches = await dataPage.$$('div[title="Click for match detail!"]');
    let numberMatches = await allMatches.length;
    await console.log(numberMatches)

    recordMatchNumber = 0;

    // Run Main Loop
    try {
        // Get game data from all matches
        for (let i = 1; i < numberMatches; i++) {
            recordMatchNumber = recordMatchNumber + 1;
            await console.log('Match number is:'); await console.log(i)
            let currentMatch = await allMatches[i];
            await currentMatch.click();

            const newPagePromise = new Promise(x => browser.once('targetcreated', target => x(target.page())));
            const popup = await newPagePromise;

            try {
                await popup.waitForSelector('a[href="#/match-summary/point-by-point"]', { timeout: 1500 });
                let pointByPointButton = await popup.$('a[href="#/match-summary/point-by-point"]');
                await pointByPointButton.click();
                await dataPage.waitForTimeout(100);

            } catch (error) {
                // Go to next match
                await popup.close();
                continue;
            }


            // Get data from all sets played in game
            try {
                await popup.waitForSelector('div[class="subFilter__group"]', { timeout: 1500 });
                let setsBar = await popup.$('div[class="subFilter__group"]');
                let allSets = await setsBar.$$('[title]');
                numberSets = await allSets.length;
            } catch (error) {
                await popup.close();
                continue;
            }

            // Check if playerName is switched
            await popup.waitForSelector('div[class="participant__participantNameWrapper"]');
            let nameBar = await popup.$('div[class="participant__participantNameWrapper"]');
            let firstName = await nameBar.evaluate(node => node.innerText);
            if ((firstName.localeCompare(playerName)) == 0) {
                namesSwitched = 0;
            } else {
                namesSwitched = 1;
                await console.log('Names are switched')
            }

            // Loop through all sets of the current match
            for (let j = 0; j < numberSets; j++) {
                await (allSets[j]).click();
                await popup.waitForSelector('div[class="matchHistoryRow"]');
                allGames = await popup.$$('div[class="matchHistoryRow"]');
                numberGames = await allGames.length;
                dataMatrix[n] = [n];
                // Loop through all games of the set
                for (let k = 0; k < numberGames; k++) {
                    let currentGame = allGames[k];
                    let score = await currentGame.evaluate(node => node.innerText);
                    var numb = score.match(/\d/g); // Get numbers in mixed array
                    numb = numb.join("");
                    //await console.log(numb[0])
                    if (namesSwitched == 0) {
                        let actualNumber = numb[0];
                        dataMatrix[n][k] = actualNumber;
                    } else {
                        let actualNumber = numb[1];
                        dataMatrix[n][k] = actualNumber;
                    }
                    // Check is match has gone to tie breaks
                    let arrayLength = await numb.length;
                    if (arrayLength > 2) {
                        ii = score.indexOf("-") 
                        if (namesSwitched == 0) {
                            let actualNumber = score[ii-2];
                            dataMatrix[n][k] = actualNumber;
                        } else {
                            let actualNumber = score[ii+2];
                            dataMatrix[n][k] = actualNumber;
                        }
                        break;
                    } 
                }
                dataMatrix[n][numberGames] = -1;
                n = n + 1;
                await console.log('New set')
                await popup.waitForTimeout(100);
            }
            await popup.close();

            if (recordMatchNumber == 30) {
                const arrayToTxtFile = require('array-to-txt-file')
                await arrayToTxtFile([dataMatrix], './Tennis_Djokovic_N_Data_1.txt', err => {
                    if (err) {
                        console.error(err)
                        return
                    }
                    // console.log('Successfully wrote to txt file') 73!!!!!!
                })
                recordMatchNumber = 0;
            }
            // Write Data into a text file
            const arrayToTxtFile = require('array-to-txt-file')
   /*         await arrayToTxtFile([dataMatrix], './Tennis_Ymer_E_Data_1.txt', err => {
                if (err) {
                    console.error(err)
                    return
                }
                // console.log('Successfully wrote to txt file')
            })*/
        }
    } catch (error) {
        // Write Data into a text file
        const arrayToTxtFile = require('array-to-txt-file')
        await arrayToTxtFile([dataMatrix], './Tennis_Djokovic_N_Data_1.txt', err => {
            if (err) {
                console.error(err)
                return
            }
            // console.log('Successfully wrote to txt file')!!!!!!
        })
    }

    const arrayToTxtFile = require('array-to-txt-file')
    await arrayToTxtFile([dataMatrix], './Tennis_Djokovic_N_Data_1.txt', err => {
        if (err) {
            console.error(err)
            return
        }
        // console.log('Successfully wrote to txt file') !!!!!!
    })

    await browser.close();
})();

