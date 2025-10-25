#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            DEPLOYING IMS TO KUBERNETES                       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

if [ ! -f "01-namespace.yaml" ]; then
    echo -e "${RED}✗ Error: YAML files not found${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/6] Creating namespace...${NC}"
kubectl apply -f 01-namespace.yaml
echo -e "${GREEN}✓ Namespace created${NC}"
echo ""

echo -e "${YELLOW}[2/6] Creating persistent volumes...${NC}"
kubectl apply -f 02-pv-mongo.yaml
kubectl apply -f 03-pv-mysql.yaml
echo -e "${GREEN}✓ PVCs created${NC}"
echo ""

echo -e "${YELLOW}[3/6] Deploying MySQL...${NC}"
kubectl apply -f 04-deployment-mysql.yaml
echo "Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql -n ims --timeout=120s
echo -e "${GREEN}✓ MySQL deployed${NC}"
echo ""

echo -e "${YELLOW}[4/6] Deploying MongoDB...${NC}"
kubectl apply -f 05-deployment-mongo.yaml
echo "Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mongo -n ims --timeout=120s
echo -e "${GREEN}✓ MongoDB deployed${NC}"
echo ""

echo -e "${YELLOW}[5/6] Creating IMS services...${NC}"
kubectl apply -f 10-services-ims.yaml
echo -e "${GREEN}✓ IMS services created${NC}"
echo ""

echo -e "${YELLOW}[6/6] Deploying IMS components...${NC}"
for file in *-deployment.yaml; do
    if [ "$file" != "04-deployment-mysql.yaml" ] && [ "$file" != "05-deployment-mongo.yaml" ]; then
        echo "Applying $file..."
        kubectl apply -f $file
    fi
done
echo -e "${GREEN}✓ IMS components deployed${NC}"
echo ""

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║              IMS DEPLOYMENT COMPLETED                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "  1. Run ./create-configmaps.sh"
echo "  2. Run ./init-mysql-databases.sh"
echo "  3. Check: kubectl get pods -n ims -w"
echo ""
