OUTPUT_DIR="${DWARF_DSYM_FOLDER_PATH}/strip"
rm -rf "$OUTPUT_DIR"
mkdir "$OUTPUT_DIR"

INPUT_FRAMEWORK_BINARY=`find ${DWARF_DSYM_FOLDER_PATH}/${FRAMEWORKS_FOLDER_PATH}/ -type f -name AppNexusOASSDK`
OUTPUT_FRAMEWORK_BINARY="${OUTPUT_DIR}/AppNexusOASSDK"

# remove simulator arch from the release
if [ "$CONFIGURATION" == "Release" ]; then
if [  "$CURRENT_ARCH" != "x86_64" ]; then

lipo "${INPUT_FRAMEWORK_BINARY}" -verify_arch x86_64
if [ $? == 0 ] ; then
REMOVE_ARCHS="-remove x86_64"
arch_found=true
fi

lipo "${INPUT_FRAMEWORK_BINARY}" -verify_arch i386
if [ $? == 0 ] ; then
REMOVE_ARCHS="${REMOVE_ARCHS} -remove i386"
arch_found=true
fi

if [ "$arch_found" == "true" ]; then
lipo ${REMOVE_ARCHS} "${INPUT_FRAMEWORK_BINARY}" -output "${OUTPUT_FRAMEWORK_BINARY}"

cp -f "${OUTPUT_FRAMEWORK_BINARY}" "${INPUT_FRAMEWORK_BINARY}"
rm -rf "$OUTPUT_DIR"

codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --timestamp=none --verbose `dirname ${INPUT_FRAMEWORK_BINARY}`
fi

fi
fi