echo "\n----- Starting a new Flutter application -----\n\n"
echo "Enter project repo name: "
read newname
testNewName=${newname//-/_} #replace "-" characters with "_"

echo "\n----- Change bundleId -----\n\n"
echo "Enter bundleId: "
read newbundleID

oldBundleID="com.boilerplate"

#  App name

echo "\n----- Change App Display Name  -----\n\n"
echo "Enter AppName: "
read newAppName
oldAppName="BoilerPlateNameReplace"

# iOS

rm -rf Pods/
mkdir "../$newname"
cp -r ./ "../$newname"
cd "../$newname"
mv README-TEMPLATE.md README.md

cd "ios/"

find . -type f -name "*.xcconfig" -exec sed -i "" "s/$oldAppName/$newAppName/g" {} \; #Rename boilerplate mentions on config files
find . -type f -name "*.xcconfig" -exec sed -i "" "s/$oldBundleID/$newbundleID/g" {} \; #Rename boilerplate mentions on config files
sed -i "" "s/$oldAppName/$newAppName/g" ./README.md

rm Podfile.lock
rm setup.sh
cd ..

# Android 
cd android/app

sed -i "" "s/$oldBundleID/$newbundleID/g" ./build.gradle
sed -i "" "s/$oldAppName/$newAppName/g" ./build.gradle

cd ..
cd ..
flutter pub get
cd ios/
pod install