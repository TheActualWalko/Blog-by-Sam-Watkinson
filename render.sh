#!/bin/bash
database=`cat articles-database`

publicDir="compiled"

permaSuffix="/index.html"
previewDocName="preview-content.html"
articleDocName="/article-content.html"

permaTopTemplate="templates/perma-top.html"
permaBottomTemplate="templates/perma-bottom.html"
pageTopTemplate="templates/page-top.html"
pageBottomTemplate="templates/page-bottom.html"

articlesPerPage="3"

currentArticleDir=""
articlesForCurrentPage=""
articleIndex=0
indexPageWritten=0

buildIndexPage(){
  `cat $pageTopTemplate $articlesForCurrentPage$pageBottomTemplate > $publicDir/index.html`
}

buildMultiArticleDocument(){
  let "pageIndex += 1"
  `mkdir $publicDir/page/$pageIndex`
  `cat $pageTopTemplate $articlesForCurrentPage$pageBottomTemplate > $publicDir/page/$pageIndex/index.html`

  if [ $indexPageWritten -eq 0 ]; then
    buildIndexPage
    indexPageWritten=1
  fi
}

buildPermalinkDocument(){
  `cat $permaTopTemplate $currentArticleDir$articleDocName $permaBottomTemplate > $publicDir/$currentArticleDir$permaSuffix`
}

render(){
  for articleDir in $database; do
    currentArticleDir=$articleDir;
    buildPermalinkDocument
    articlesForCurrentPage="$articlesForCurrentPage$currentArticleDir/$previewDocName "
    let "articleIndex += 1"
    if [ `expr $articleIndex % $articlesPerPage` -eq 0 ]; then
      buildMultiArticleDocument
      articlesForCurrentPage=""
    fi
  done

  # build the remainder articles
  if [ articlesForCurrentPage != "" ]; then
    buildMultiArticleDocument
    articlesForCurrentPage=""
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