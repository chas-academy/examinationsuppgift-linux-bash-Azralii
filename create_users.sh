
# 1. Rätt namn
mv create_users.sh create_users.sh

# 2. Rättigheter
chmod +x create_users.sh

# 3. Fix line endings
dos2unix create_users.sh

# 4. Push igen
git add .
git commit -m "fix script execution"
git push

