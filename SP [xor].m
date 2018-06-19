%SP xor
rounds = 13;
src = '0x3C3C34CB';
x1 = hexToBinaryVector(src,32);
s = cell(8,1);
s{1} = '0x80A7F62ED9451CB3';s{2} = '0xE578A2CF941D036B';
s{3} = '0x6E82B93D7F015C4A';s{4} = '0x50A9B48731ECD62F';
s{5} = '0x71FB645C0E8DA932';s{6} = '0x7D2CBA450E3F6891';
s{7} = '0xDAFB9204C3675E81';s{8} = '0xB5721E40AC3FD689';
pt = [8 10 30 23 26 13 4 24 5 11 14 27 6 12 18 7 15 32 2 1 19 22 29 17 9 16 3 21 28 25 20 31];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ROUND KEYs GENERATION   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textKey = '0x96BA6F3E'; 
binaryKey = hexToBinaryVector(textKey,32); 
keySet = cell(rounds,1); 
keySet{1} = binaryKey; 
%tmp = binaryVectorToHex(keySet{1}); 
for i = 2:rounds
%keySet{i} = hexToBinaryVector(dec2hex(mod(11111+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^3,2^32)),32); 
    sM = zeros(1,15);
    keySet{i} = zeros(1,32);
    sM = keySet{i-1}(18:32);
    
    for j=1:32
        if (j < 16)
            keySet{i}(j) = sM(j);
        else
            keySet{i}(j) = keySet{i-1}(j-15);
        end
    end
%     if( mod(i,4) == mod(0,4) || mod(i,4) == mod(1,4)) 
%         keySet{i} = binaryKey(1:32); 
%     else 
%         keySet{i} = binaryKey(33:64); 
%     end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ENCRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text = x1;

for i = 1:rounds
   
   tmpT = num2str( binaryVectorToHex(xor(text, keySet{i})));
   
   %display(tmpT, 'T+K');
    
    for j=1:length(tmpT)
        tmpT(j) = s{j}(hex2dec(tmpT(j))+1+2);
    end

    %display(tmpT, 'T S')
    
    tmpT = hexToBinaryVector(tmpT,32);
    % P - substitution
    temp = tmpT;
    for j=1:length(tmpT)
        tmpT(j) = temp(pt(j));
    end
    
    %display(binaryVectorToHex(tmpT), 'T P')
    
    text =  tmpT;
     
end
encrypted(1:32) = text;      %
binaryVectorToHex(encrypted)  %x1 C1EADC23 x2 C0911C14

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        DECRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% text1 = encrypted;

text1 = x1;

for i = 1:rounds
    % SP -substitution for right block
    % S - substitution
    
   % tmpT = text1;
    
    temp = text1;
    for j=1:length(text1)
        text1(pt(j)) = temp(j);
    end
    
    %display(binaryVectorToHex(text1), 'T P')
    
    tmpT = num2str (binaryVectorToHex(text1));
    
    for j=1:length(tmpT)
        
        unitS = num2str(s{j});
        for k=3:length(unitS)

            if(tmpT(j) == s{j}(k))
                tmpT(j) = num2str(dec2hex(k - 3));
                break
            end
            
        end
        
    end
   % display(tmpT, 'T S')
     
    temp = hexToBinaryVector(tmpT,32);
    tmpT = xor(temp, keySet{rounds-i+1});
    text1 = tmpT;
      
end
decrypted(1:32) = text1;      
binaryVectorToHex(decrypted)    


