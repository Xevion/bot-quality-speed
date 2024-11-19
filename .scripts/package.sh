#!/bin/bash

infoFile="$(git rev-parse --show-toplevel)/info.json"

modName=$(jq -r '.name' $infoFile)
if [ -z "$modName" ]; then
    echo "Error: Mod name not found in info.json"
    exit 1
fi

version=$(jq -r '.version' $infoFile)
if [ -z "$version" ]; then
    echo "Error: Mod version not found in info.json"
    exit 1
fi

outputFile="${modName}_${version}.zip"

git archive --format zip --prefix $modName/ --worktree-attributes --output ./$outputFile HEAD
if [ $? -ne 0 ]; then
    echo "Error: Failed to package mod"
    exit 1
else
    size=$(du -h $outputFile | cut -f1)
    echo "Mod packaged: ./$outputFile ($size)"
fi
