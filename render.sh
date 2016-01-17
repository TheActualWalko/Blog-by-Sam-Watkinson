#!/bin/bash
database=`cat articles-database`

publicDir="public"

permaSuffix="/index.html"
previewSuffix="/preview-content.html"
articleSuffix="/article-content.html"

permaTopTemplate="templates/perma-top.html"
permaBottomTemplate="templates/perma-bottom.html"
pageTopTemplate="templates/page-top.html"
pageBottomTemplate="templates/page-bottom.html"

articlesPerPage="3"

lastArticle=""
lastLines=""
articleIndex=0
indexPageWritten=0

buildIndexPage(){
  `cat $pageTopTemplate $lastLines$pageBottomTemplate > $publicDir/index.html`
}

buildPage(){
  let "pageIndex += 1"
  `mkdir $publicDir/page/$pageIndex`
  `cat $pageTopTemplate $lastLines$pageBottomTemplate > $publicDir/page/$pageIndex/index.html`

  if [ $indexPageWritten -eq 0 ]; then
    buildIndexPage
    indexPageWritten=1
  fi
}

buildPermalink(){
  `cat $permaTopTemplate $lastArticle$articleSuffix $permaBottomTemplate > $publicDir/$lastArticle$permaSuffix`
}

render(){
  for line in $database; do
    lastArticle=$line;
    buildPermalink
    lastLines="$lastLines$lastArticle$previewSuffix "
    let "articleIndex += 1"
    if [ `expr $articleIndex % $articlesPerPage` -eq 0 ]; then
      buildPage $lastLines
      lastLines=""
    fi
  done
  if [ lastLines != "" ]; then
    buildPage
    lastLines=""
  fi
}

clean(){
  `rm -r $publicDir`
  `mkdir $publicDir`
  `mkdir $publicDir/page`
  `cp -R articles $publicDir/articles`
  `cp -R css $publicDir/css`
  `cp -R fonts $publicDir/fonts`
}

clean
render