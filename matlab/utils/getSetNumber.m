function setNumber = getSetNumber(url)
html = webread(url);

% Parse the HTML content
tree = htmlTree(html);

% Use the CSS selector to locate elements
selector = 'td[class="mp_info_txt"]';
elements = findElement(tree, selector);


str = extractHTMLText(elements);
ind= find(str == '0-0');
setNumber = length(ind);
end